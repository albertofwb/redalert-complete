#!/bin/bash
# redalert-complete: Red Alert "Mission Complete" voice for Claude Code hooks
# 红警版任务完成提示音效
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
CONFIG="$RA_DIR/config.json"

# --- 音频播放 ---
play_sound() {
  local file="$1" vol="${2:-0.8}"
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
      # Linux with pulseaudio/alsa
      if command -v paplay >/dev/null 2>&1; then
        nohup paplay "$file" >/dev/null 2>&1 &
      elif command -v aplay >/dev/null 2>&1; then
        nohup aplay "$file" >/dev/null 2>&1 &
      elif command -v ffplay >/dev/null 2>&1; then
        nohup ffplay -nodisp -autoexit -volume "$(echo "$vol * 100" | bc)" "$file" >/dev/null 2>&1 &
      else
        echo "警告: 未找到音频播放器 (paplay/aplay/ffplay)" >&2
      fi
      ;;
  esac
}

# --- 通知 ---
send_notification() {
  local msg="$1" title="${2:-Claude Code}"
  case "$PLATFORM" in
    mac)
      nohup osascript - "$msg" "$title" >/dev/null 2>&1 <<'APPLESCRIPT' &
on run argv
  display notification (item 1 of argv) with title (item 2 of argv)
end run
APPLESCRIPT
      ;;
    wsl)
      powershell.exe -Command "
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType=WindowsRuntime] | Out-Null
        [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom, ContentType=WindowsRuntime] | Out-Null
        \$xml = [Windows.Data.Xml.Dom.XmlDocument]::new()
        \$xml.LoadXml('<toast><visual><binding template=\"ToastGeneric\"><text>Claude Code</text><text>$msg</text></binding></visual></toast>')
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier('Claude Code').Show(\$xml)
      " &>/dev/null &
      ;;
    linux)
      if command -v notify-send >/dev/null 2>&1; then
        nohup notify-send "$title" "$msg" >/dev/null 2>&1 &
      fi
      ;;
  esac
}

# --- 主逻辑 ---
SOUND_FILE="$RA_DIR/sounds/mission_complete.wav"

# 检查音效文件
if [[ ! -f "$SOUND_FILE" ]]; then
  echo "错误: 音效文件不存在: $SOUND_FILE" >&2
  echo "请先运行安装脚本下载音效" >&2
  exit 1
fi

# 播放音效
play_sound "$SOUND_FILE" 0.8

# 发送通知
send_notification "任务完成！" "Claude Code"
