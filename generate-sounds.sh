#!/bin/bash
# 生成红警风格测试音效
# 为每个经典语音生成对应的音调

SOUNDS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/sounds"
mkdir -p "$SOUNDS_DIR"

echo "🎵 生成红警音效..."
echo ""

# Mission Complete - 经典的上升音调
echo "🔊 生成: mission_complete.wav (Mission Complete)"
ffmpeg -y -f lavfi -i "sine=frequency=523.25:duration=0.15" \
       -f lavfi -i "sine=frequency=659.25:duration=0.15" \
       -f lavfi -i "sine=frequency=783.99:duration=0.2" \
       -f lavfi -i "sine=frequency=1046.50:duration=0.4" \
       -filter_complex "[0:a][1:a][2:a][3:a]concat=n=4:v=0:a=1,asetrate=44100*0.95,atempo=1.05[out]" \
       -map "[out]" "$SOUNDS_DIR/mission_complete.wav" 2>/dev/null

# Unit Ready - 短促上升音
echo "🔊 生成: unit_ready.wav (Unit Ready)"
ffmpeg -y -f lavfi -i "sine=frequency=440:duration=0.08" \
       -f lavfi -i "sine=frequency=554:duration=0.1" \
       -f lavfi -i "sine=frequency=659:duration=0.2" \
       -filter_complex "[0:a][1:a][2:a]concat=n=3:v=0:a=1[out]" \
       -map "[out]" "$SOUNDS_DIR/unit_ready.wav" 2>/dev/null

# Building - 稳定中音
echo "🔊 生成: building.wav (Building)"
ffmpeg -y -f lavfi -i "sine=frequency=392:duration=0.1" \
       -f lavfi -i "sine=frequency=392:duration=0.15" \
       -f lavfi -i "sine=frequency=523:duration=0.25" \
       -filter_complex "[0:a][1:a][2:a]concat=n=3:v=0:a=1[out]" \
       -map "[out]" "$SOUNDS_DIR/building.wav" 2>/dev/null

# New Construction Options - 轻快上扬
echo "🔊 生成: new_options.wav (New Construction Options)"
ffmpeg -y -f lavfi -i "sine=frequency=523:duration=0.08" \
       -f lavfi -i "sine=frequency=659:duration=0.08" \
       -f lavfi -i "sine=frequency=784:duration=0.1" \
       -f lavfi -i "sine=frequency=880:duration=0.15" \
       -filter_complex "[0:a][1:a][2:a][3:a]concat=n=4:v=0:a=1,asetrate=44100*1.1[out]" \
       -map "[out]" "$SOUNDS_DIR/new_options.wav" 2>/dev/null

# Cannot Deploy Here - 下降音（错误提示）
echo "🔊 生成: cannot_deploy.wav (Cannot Deploy Here)"
ffmpeg -y -f lavfi -i "sine=frequency=392:duration=0.12" \
       -f lavfi -i "sine=frequency=311:duration=0.15" \
       -f lavfi -i "sine=frequency=247:duration=0.25" \
       -filter_complex "[0:a][1:a][2:a]concat=n=3:v=0:a=1[out]" \
       -map "[out]" "$SOUNDS_DIR/cannot_deploy.wav" 2>/dev/null

# Building Silos Needed - 警告音
echo "🔊 生成: silos_needed.wav (Building Silos Needed)"
ffmpeg -y -f lavfi -i "sine=frequency=659:duration=0.1" \
       -f lavfi -i "sine=frequency=494:duration=0.12" \
       -f lavfi -i "sine=frequency=523:duration=0.15" \
       -f lavfi -i "sine=frequency=392:duration=0.2" \
       -filter_complex "[0:a][1:a][2:a][3:a]concat=n=4:v=0:a=1[out]" \
       -map "[out]" "$SOUNDS_DIR/silos_needed.wav" 2>/dev/null

echo ""
echo "✅ 音效生成完成！"
echo ""
ls -la "$SOUNDS_DIR"
