# 本地元数据补充与核验

仅在应用工具的枚举不完整或保护字段不足时读取本文件。优先使用工具；本地存储属于应用实现细节，以下是 2026-09-05 的实测位置和字段，执行时先验证当前结构。

## 发现全部本地目标

1. 根目录使用环境变量 `CODEX_HOME`；未设置时为用户目录下的 `.codex`。不要硬编码某个用户名。
2. 只列举必要的 `state_*.sqlite` 和 `.codex-global-state.json`。多个数据库并存时，根据当前 schema 和工具返回的已知任务确认正在使用哪一个，不仅凭文件名最大的版本号选择。
3. SQLite 使用只读 URI，例如 Python：
   `sqlite3.connect(db_path.resolve().as_uri() + "?mode=ro", uri=True)`。
   先查 `sqlite_master` 和 `PRAGMA table_info(threads)`，只选择存在且需要的列。
4. 清点任务 ID、来源、工作目录、创建时间、归档和项目字段。避免输出整个 `title`、`preview` 或 `first_user_message` 列：部分旧任务的 `title` 是完整长提示词，会淹没上下文。
5. 用发现的 ID 调用 `read_thread`，取得应用实际标题、`createdAt` 和内容。数据库仅补充发现，不把未验证的内部记录直接当成侧栏用户对话。

实测 `threads.source` 中 `cli`、`vscode` 常用于用户任务，JSON 形式的 `subagent` 包括 guardian 和内部执行任务。另有 `thread_source` 可区分 `user`、`automation`、`subagent`、`guardian_review`。综合这些字段和应用证据判断，不能只按工作目录前缀批量纳入所有内部记录。

## 归属映射

优先使用工具返回的 `projectId`。旧记录的数据库 `project_id` 可能为空，但应用仍通过旧版映射把任务放在项目下。

在 global state 中按需读取这些键：
- `local-projects`：项目 ID、名称与 `rootPaths`。
- `thread-project-assignments`：显式任务归属。
- `thread-workspace-root-hints`：worktree 对应的项目根。
- `projectless-thread-ids`：显式无项目任务。
- `sidebar-project-thread-orders`、`project-order`：用户侧栏顺序。

按显式归属、工作区提示、可证明的根目录匹配逐层判断。Windows 路径可以在内存中统一大小写、分隔符并处理 `\\\\?\\` 前缀；只用于匹配，不写回存储。嵌套项目需最具体的可证实归属，worktree 不能仅凭末尾文件夹同名归入项目。无法确定的记录标为归属未知，不猜测。

读取 global state 时仅输出相关键；不要输出账号信息、提示词历史、配置草稿、连接信息或凭据。全量读取会话正文也不是清点的必要步骤。

## 保护状态的前后对照

在确认后的写入前保存快照，核验时仅比较对应保护字段：
- 项目：ID、名称和顺序。
- 对话：ID、项目归属、归档、置顶、侧栏 section 及位置。
- 实测旧库另有 `recency_at`、`recency_at_ms`、`section_position`、`section_entered_at_ms` 等排序相关字段；按当前 schema 选取。
- 若检查正文或首条用户消息，只在本地计算摘要用于比较，不把全文输出到工具日志。

当前任务仍在运行，`updatedAt` 变化属于正常活动；旧任务的 API 也可能在读取或重命名时重建元数据。把创建时间、活动时间和侧栏排序字段分开看。遇到并发变化时先确认是否来自其他正在运行的工作，不用旧快照覆盖新状态。

2026-09-05 的验证表明：新任务的显示名称可能在 `name`，旧任务可能更新 `title`。因此“只有少数 name 匹配”不能推断其他改名失败；最终用 `read_thread` 的标题和侧栏工具返回值核验。

所有本地访问保持只读。不要修改 `state_*.sqlite`、`session_index.jsonl`、global state 或 rollout JSONL 来应用标题，也不要伪造侧栏缓存。接口无法支持的目标保留并在结果中报告。
