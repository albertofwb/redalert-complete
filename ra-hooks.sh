#!/bin/bash
# redalert-hooks: 完整红警音效系统 for Claude Code
# 根据不同场景播放不同音效

set -uo pipefail

# --- 平台检测 ---
detect_platform() {
  case "$(uname -s)" in
    Darwin) echo "mac" ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi ;;
    *) echo "unknown" ;;
  esac
}
PLATFORM=$(detect_platform)

RA_DIR="${CLAUDE_RA_DIR:-$HOME/.claude/hooks/redalert-complete}"
SOUNDS_DIR="$RA_DIR/sounds"

# --- 音频播放 ---
play_sound() {
  local file="$1" vol="${2:-0.7}"
  
  if [[ ! -f "$file" ]]; then
    # 如果找不到指定音效，尝试用默认的
    return 0
  fi
  
  case "$PLATFORM" in
    mac)
      nohup afplay -v "$vol" "$file" >/dev/null 2>&1 &
      ;;
    wsl)
      local wpath
      wpath=$(wslpath -w "$file")
      wpath="${wpath//\\//}"
      powershell.exe -NoProfile -NonInteractive -Command "
        Add-Type -AssemblyName PresentationCore
        \$p = New-Object System.Windows.Media.MediaPlayer
        \$p.Open([Uri]::new('file:///$wpath'))
        \$p.Volume = $vol
        Start-Sleep -Milliseconds 200
        \$p.Play()
        Start-Sleep -Seconds 3
        \$p.Close()
      " &>/dev/null &
      ;;
    linux)
      if command -v paplay >/dev/null 2>&1; then
        nohup paplay "$file" >/dev/null 2>&1 &
      elif command -v aplay >/dev/null 2>&1; then
        nohup aplay "$file" >/dev/null 2>&1 &
      elif command -v ffplay >/dev/null 2>&1; then
        nohup ffplay -nodisp -autoexit -volume "$(echo "$vol * 100" | bc)" "$file" >/dev/null 2>&1 &
      fi
      ;;
  esac
}

# --- 主逻辑 ---
HOOK_TYPE="${1:-complete}"

# 支持的音效类型
case "$HOOK_TYPE" in
  "startup")
    # 启动时 - Unit Ready / Construction Complete
    play_sound "$SOUNDS_DIR/unit_ready.wav" 0.6
    ;;
  "building")
    # 开始工作时 - Building / Training
    play_sound "$SOUNDS_DIR/building.wav" 0.7
    ;;
  "complete"|"success")
    # 完成时 - Mission Complete / Construction Complete
    play_sound "$SOUNDS_DIR/mission_complete.wav" 0.8
    ;;
  "error"|"fail")
    # 出错时 - Cannot deploy here / Insufficient funds
    play_sound "$SOUNDS_DIR/cannot_deploy.wav" 0.8
    ;;
  "warning")
    # 警告时 - Building silos needed / Low power
    play_sound "$SOUNDS_DIR/silos_needed.wav" 0.7
    ;;
  "start")
    # 开始会话 - New construction options
    play_sound "$SOUNDS_DIR/new_options.wav" 0.6
    ;;
  *)
    # 默认播放 Mission Complete
    play_sound "$SOUNDS_DIR/mission_complete.wav" 0.8
    ;;
esac
