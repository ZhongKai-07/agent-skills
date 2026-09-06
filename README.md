# Agent Skills

个人维护的 Agent Skills 集合，用于在不同设备间同步可复用的工作流。

## Skills

| Skill | 用途 |
| --- | --- |
| [`codex-thread-titles`](skills/codex-thread-titles/) | 按创建日期、任务类型和实际内容整理 Codex 侧栏对话标题，并在修改前预览、修改后核验。 |

## 安装

克隆仓库后，可将某个 Skill 安装到指定 agent：

```powershell
.\install.ps1 -Skill codex-thread-titles -Target codex
.\install.ps1 -Skill codex-thread-titles -Target claude
.\install.ps1 -Skill codex-thread-titles -Target agents
```

macOS 或 Linux：

```bash
./install.sh codex-thread-titles codex
./install.sh codex-thread-titles claude
./install.sh codex-thread-titles agents
```

目标目录已存在时，安装脚本先创建带时间戳的备份，再复制当前版本。

默认安装位置：

| Target | 目录 |
| --- | --- |
| `codex` | `${CODEX_HOME:-~/.codex}/skills` |
| `claude` | `${CLAUDE_CONFIG_DIR:-~/.claude}/skills` |
| `agents` | `${AGENTS_HOME:-~/.agents}/skills` |

Skill 文件采用通用的 `SKILL.md` 结构，但能否真正修改对话标题，取决于宿主是否提供会话枚举、创建时间读取、标题修改和结果核验能力。当前 `codex-thread-titles` 包含 Codex 专属的工具与本地元数据适配；其他 agent 可以复用命名规则，并按宿主能力执行或只生成候选标题。

## 添加新 Skill

每个 Skill 放在 `skills/<skill-name>/` 下，至少包含带 `name` 和 `description` frontmatter 的 `SKILL.md`。需要时再添加 `agents/`、`references/`、`scripts/` 或 `assets/`。
