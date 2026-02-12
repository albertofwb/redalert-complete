# 🎮 Red Alert Complete for Claude Code

为 [Claude Code](https://docs.anthropic.com/claude/docs) 添加《红色警戒2》经典音效，让编程体验更有游戏感！

> **Mission Complete!** 🎉  
> 每次 Claude 完成任务，耳边响起熟悉的红警语音。

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux%20%7C%20WSL-green.svg)

## ✨ 功能特色

| 场景 | 触发时机 | 经典音效 |
|------|---------|---------|
| 🚀 **启动** | Claude Code 启动 | *New Construction Options* |
| 🔨 **开工** | 执行工具/命令前 | *Building...* |
| ✅ **完成** | 任务执行成功 | *Mission Complete!* |
| ❌ **错误** | 任务失败/出错 | *Cannot deploy here!* |
| ⚠️ **警告** | 需要注意时 | *Building silos needed* |

## 🚀 快速安装

```bash
# 1. 克隆仓库
git clone https://github.com/albertofwb/redalert-complete.git
cd redalert-complete

# 2. 运行安装脚本
bash install.sh
```

## 📦 手动安装

```bash
# 1. 创建 hooks 目录
mkdir -p ~/.claude/hooks/redalert-complete

# 2. 复制脚本
cp ra-*.sh ~/.claude/hooks/redalert-complete/
chmod +x ~/.claude/hooks/redalert-complete/*.sh

# 3. 生成/放置音效文件
bash ~/.claude/hooks/redalert-complete/generate-sounds.sh

# 或者手动下载真实红警音效到 sounds/ 目录
```

## ⚙️ 配置 Claude Code

编辑 `~/.claude/settings.json`，添加 hooks：

```json
{
  "hooks": {
    "OnStart": [
      "/home/albert/.claude/hooks/redalert-complete/ra-hooks.sh start"
    ],
    "BeforeToolUse": [
      "/home/albert/.claude/hooks/redalert-complete/ra-hooks.sh building"
    ],
    "AfterToolUse": [
      "/home/albert/.claude/hooks/redalert-complete/ra-complete.sh"
    ]
  }
}
```

> 💡 注意：将路径替换为你的实际安装路径

## 🔊 音效文件

### 当前方案：合成音效
项目包含 `generate-sounds.sh` 脚本，使用 FFmpeg 生成红警风格的音调音效。

### 推荐：真实游戏音效
使用 XCC Mixer 从红警2游戏文件提取：

```bash
# 需要提取的文件（位于游戏目录 sounds.mix）
- MUON0000.WAV → mission_complete.wav
- RUNI0000.WAV → unit_ready.wav  
- RBLD0000.WAV → building.wav
- RNEW0000.WAV → new_options.wav
- RCAN0000.WAV → cannot_deploy.wav
- RSIL0000.WAV → silos_needed.wav
```

**音效来源**：
- [XCC Mixer 下载](http://xhp.xwis.net/) - 提取游戏资源
- [MyInstants Red Alert](https://www.myinstants.com/search/red-alert/) - 在线音效

## 🎮 支持的 Hooks

Claude Code 支持以下 hook 点：

| Hook | 触发时机 | 建议音效 |
|------|---------|---------|
| `OnStart` | Claude 启动时 | New Construction Options |
| `BeforeToolUse` | 使用工具前 | Building |
| `AfterToolUse` | 使用工具后 | Mission Complete |
| `OnExit` | Claude 退出时 | （可选） |

## 🛠️ 系统要求

- **macOS**: 自带 `afplay`
- **Linux**: `paplay`, `aplay`, 或 `ffplay` 任一
- **WSL**: PowerShell + Windows Media Player

安装依赖（Linux）：
```bash
sudo apt-get install pulseaudio-utils   # for paplay
# 或
sudo apt-get install sox                # for play
```

## 🧪 测试

```bash
# 测试各场景音效
bash ~/.claude/hooks/redalert-complete/ra-hooks.sh start      # 启动
bash ~/.claude/hooks/redalert-complete/ra-hooks.sh building   # 开工
bash ~/.claude/hooks/redalert-complete/ra-hooks.sh complete   # 完成
bash ~/.claude/hooks/redalert-complete/ra-hooks.sh error      # 错误
```

## 📝 自定义扩展

想要更多音效？编辑 `ra-hooks.sh` 添加新场景：

```bash
"training")
  play_sound "$SOUNDS_DIR/training.wav" 0.7
  ;;
"insufficient_funds")
  play_sound "$SOUNDS_DIR/insufficient_funds.wav" 0.8
  ;;
```

## 🤝 相关项目

- [peon-ping](https://github.com/tonyyont/peon-ping) - Warcraft III 苦工语音版
- [Claude Code 官方文档](https://docs.anthropic.com/claude/docs/claude-code-hooks)

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE)

## 🙏 致谢

- 音效版权归 © EA / Westwood Studios 所有
- 本项目仅供学习和娱乐使用

---

**享受红警风格的编程体验吧！** 🚁💥
