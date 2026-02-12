# 🎮 给 Claude Code 加上红警音效，编程像打游戏一样爽！

> 本文介绍如何为 Claude Code 添加《红色警戒2》经典音效，让每次 AI 助手完成任务都伴随熟悉的 "Mission Complete"！

---

## 前言

作为一个程序员，每天用 Claude Code 写代码、调试程序是常态。但你是否觉得，每次 Claude 默默完成任务后，少了点...仪式感？

于是我想到：能不能像游戏一样，给 Claude 加上音效反馈？

**红警2 的经典语音再合适不过了！**

---

## 效果预览

用 Claude Code 写代码时，你会听到：

| 场景 | 音效 |
|------|------|
| 🚀 Claude 启动 | *New Construction Options* |
| 🔨 开始执行命令 | *Building...* |
| ✅ 任务完成 | **Mission Complete!** |
| ❌ 出错了 | *Cannot deploy here!* |

每次听到 "Mission Complete" 的成就感，完全不亚于当年推掉敌人基地！

---

## 项目地址

**GitHub**: https://github.com/albertofwb/redalert-complete

欢迎 Star ⭐ 和 Fork！

---

## 快速安装

### 1. 克隆仓库

```bash
git clone https://github.com/albertofwb/redalert-complete.git
cd redalert-complete
```

### 2. 一键安装

```bash
bash install.sh
```

安装脚本会自动：
- ✅ 检测系统平台
- ✅ 复制脚本到 `~/.claude/hooks/`
- ✅ 生成红警风格音效
- ✅ 配置 Claude Code

### 3. 手动配置（可选）

编辑 `~/.claude/settings.json`：

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash /home/albert/.claude/hooks/redalert-complete/ra-hooks.sh start"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "bash /home/albert/.claude/hooks/redalert-complete/ra-hooks.sh building"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "bash /home/albert/.claude/hooks/redalert-complete/ra-complete.sh"
          }
        ]
      }
    ]
  }
}
```

**配置说明：**
- `SessionStart`: Claude 启动时触发
- `PreToolUse`: 工具调用前触发（这里只匹配 `Bash` 命令）
- `PostToolUse`: 工具调用成功后触发
- `matcher`: `"*"` 表示匹配所有，也可用 `"Bash|Edit|Write"` 匹配特定工具

---

## 技术原理

Claude Code 提供了 **Hooks 机制**，可以在不同节点触发自定义脚本：

| Hook 事件 | 触发时机 |
|----------|---------|
| `SessionStart` | 会话开始时 |
| `PreToolUse` | 工具调用前 |
| `PostToolUse` | 工具调用成功后 |
| `PostToolUseFailure` | 工具调用失败后 |
| `SessionEnd` | 会话结束时 |

Claude Code 的 hooks 配置需要特定格式：
- **`matcher`**: 正则表达式匹配触发条件，`*` 表示匹配所有
- **`type`**: `"command"` 表示执行 shell 命令
- **`command`**: 实际执行的命令路径

### 跨平台音频播放

项目支持 macOS、Linux、WSL：

- **macOS**: `afplay`
- **Linux**: `paplay` / `aplay` / `ffplay`
- **WSL**: PowerShell MediaPlayer

---

## 音效说明

### 当前方案

项目默认使用 **FFmpeg 合成** 的红警风格音调音效，无需游戏文件即可体验。

### 进阶：真实游戏音效

如果你拥有红警2游戏，可以用 **XCC Mixer** 提取真实音效：

```bash
# 从 sounds.mix 提取
- MUON0000.WAV → mission_complete.wav (Mission Complete)
- RBLD0000.WAV → building.wav (Building)
- RNEW0000.WAV → new_options.wav (New Construction Options)
- RCAN0000.WAV → cannot_deploy.wav (Cannot deploy here)
```

下载 XCC Mixer: http://xhp.xwis.net/

---

## 扩展玩法

### 添加更多音效

编辑 `ra-hooks.sh`，可以自定义更多场景：

```bash
"insufficient_funds")
  play_sound "$SOUNDS_DIR/insufficient_funds.wav" 0.8
  ;;  # 资源不足时（比如内存/磁盘不够）

"unit_promoted")
  play_sound "$SOUNDS_DIR/unit_promoted.wav" 0.7
  ;;  # 代码优化成功时
```

### 结合其他语音包

如果你喜欢其他游戏：
- **星际争霸**: *Carrier has arrived*, *Nuclear launch detected*
- **魔兽争霸**: *Work complete*, *More gold is required*
- **帝国时代**: *Wololo*, *Start the game already*

灵感参考：[peon-ping](https://github.com/tonyyont/peon-ping) - Warcraft III 苦工语音版

---

## 系统要求

- **macOS**: 原生支持
- **Linux**: 安装 `pulseaudio-utils` 或 `sox`
- **WSL**: 无需额外依赖

```bash
# Ubuntu/Debian
sudo apt-get install pulseaudio-utils

# 或
sudo apt-get install sox
```

---

## 写在最后

这个项目纯属娱乐，但真的能提升编程的幸福感 😄

每次听到 "Mission Complete"，都会有一种"又完成一项任务"的满足感。

如果你也喜欢红警，不妨试试！

---

**项目链接**: https://github.com/albertofwb/redalert-complete

觉得有趣的话，点个 ⭐ Star 支持一下呗～

---

## 相关链接

- [Claude Code 官方文档 - Hooks](https://code.claude.com/docs/en/hooks)
- [peon-ping - Warcraft III 语音版](https://github.com/tonyyont/peon-ping)
- [XCC Mixer 下载](http://xhp.xwis.net/)

---

*本文使用 Claude Code + redalert-complete 协助编写* 😉

#ClaudeCode #RedAlert #AI助手 #开发者工具 #效率工具 #红色警戒
