#!/bin/bash

dir=~
[ "$1" != "" ] && dir="$1"

cd $dir/ros2_ws
colcon build
source install/setup.bash

ros2 launch mypkg talk_listen.launch.py &
LAUNCH_PID=$!

# トピックの内容を取得
RESULT=$(timeout 10 bash -c "ros2 topic echo /reaction_topic | grep -m 1 'Listener: '")

# ノードを終了
kill $LAUNCH_PID

# デバッグ: 結果を一時的に表示
echo "DEBUG: Reaction message: $RESULT"

# テスト判定
if [[ -n "$RESULT" ]]; then
    echo "Test Passed: Communication between talker and listener is working!"
    exit 0
else
    echo "Test Failed: No valid reaction message received."
    exit 1
fi
