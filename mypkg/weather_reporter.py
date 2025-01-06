#!/usr/bin/python3
# SPDX-FileCopyrightText: 2024 Yuma Fukuya
# SPDX-License-Identifier: BSD-3-Clause
import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class WeatherReporter(Node):
    def __init__(self):
        super().__init__('weather_reporter')
        self.publisher_ = self.create_publisher(String, 'weather_advice_topic', 10)
        self.timer = self.create_timer(2.0, self.publish_weather_advice)
        self.weather_conditions = ["晴れ", "雨", "曇り", "雪", "強風"]
        self.index = 0

    def publish_weather_advice(self):
        weather = self.weather_conditions[self.index]
        advice_msg = String()

        if weather == "晴れ":
            advice_msg.data = "いい天気です！外出を楽しんでください。"
        elif weather == "雨":
            advice_msg.data = "雨が降っています。傘を忘れずに！"
        elif weather == "曇り":
            advice_msg.data = "曇り空です。過ごしやすい一日になりそうです。"
        elif weather == "雪":
            advice_msg.data = "雪が降っています。暖かくして安全に過ごしてください。"
        elif weather == "強風":
            advice_msg.data = "強風が吹いています。外出には注意してください！"

        # ログ出力を削除する
        # self.get_logger().info(f'Publishing: "{advice_msg.data}"')
        self.publisher_.publish(advice_msg)

        # 次の天気に移行
        self.index = (self.index + 1) % len(self.weather_conditions)

def main(args=None):
    rclpy.init(args=args)
    weather_reporter = WeatherReporter()
    rclpy.spin(weather_reporter)
    weather_reporter.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
