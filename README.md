# Agent Skills

个人维护的 Agent Skills 集合，用于在不同设备间同步可复用的工作流。

## Skills

| Skill | 用途 |
| --- | --- |
| [`codex-thread-titles`](skills/codex-thread-titles/) | 按创建日期、任务类型和实际内容整理 Codex 或 Claude Code 桌面应用的侧栏对话标题，并在修改前预览、修改后核验。 |
| [`ncm-cli-setup`](skills/ncm-cli-setup/) | 安装和配置 ncm-cli（网易云音乐 CLI）：安装 CLI、配置 API Key、安装 mpv 播放器、排查安装问题。 |
| [`netease-music-cli`](skills/netease-music-cli/) | 通过 ncm-cli 操作网易云音乐：搜索、播放、暂停、切歌、调音量、管理队列、播放歌单。 |
| [`netease-music-assistant`](skills/netease-music-assistant/) | 网易云音乐智能助手：分析红心偏好画像、多关键词搜索与推荐、播放控制、定时推送、创建歌单。 |

三个 `ncm-cli` / `netease-music-*` skill 随 ncm-cli 官方发布（Apache-2.0，各目录内附 `LICENSE.txt`），这里收录的是本机使用的版本，依赖已安装的 `ncm-cli` 和 `mpv`。

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

Skill 文件采用通用的 `SKILL.md` 结构，但能否真正修改对话标题，取决于宿主是否提供会话枚举、创建时间读取、标题修改和结果核验能力。`codex-thread-titles` 目前适配 Codex 应用和 Claude 桌面应用的 Code 标签页（宿主差异见 `references/`）；纯终端 CLI 等没有会话管理工具的宿主只能生成候选标题。名称保留 `codex-` 前缀以兼容已有安装和 Codex 调用。

## 添加新 Skill

每个 Skill 放在 `skills/<skill-name>/` 下，至少包含带 `name` 和 `description` frontmatter 的 `SKILL.md`。需要时再添加 `agents/`、`references/`、`scripts/` 或 `assets/`。
