#!/bin/bash

# テスト対象の天気リスト
WEATHER_LIST=("晴れ" "雨" "雪" "曇り" "強風")

for WEATHER in "${WEATHER_LIST[@]}"
do
    echo "Testing weather: $WEATHER"
    # メッセージを送信
    ros2 topic pub --once /weather_topic std_msgs/msg/String "{data: '$WEATHER'}" &

    # 少し待機してメッセージが送信されるのを確実にする
    sleep 1

    # Pythonプログラムを実行して反応を受信
    python3 << EOF
import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class ReactionTester(Node):
    def __init__(self):
        super().__init__('reaction_tester')
        self.subscription = self.create_subscription(
            String,
            'reaction_topic',
            self.reaction_callback,
            10)
        self.received_messages = []

    def reaction_callback(self, msg):
        self.get_logger().info(f'[Test] Received reaction: "{msg.data}"')
        self.received_messages.append(msg.data)

def main(args=None):
    rclpy.init(args=args)
    tester = ReactionTester()
    rclpy.spin_once(tester, timeout_sec=5.0)
    if tester.received_messages:
        print(f"Test Passed for $WEATHER: Messages received:", tester.received_messages)
    else:
        print(f"Test Failed for $WEATHER: No messages received.")
    tester.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
EOF

    # `ros2 topic pub` のバックグラウンド処理を終了させる
    wait
done
