import rclpy
from rclpy.node import Node
from std_msgs.msg import String
import random

class Talker(Node):
    def __init__(self):
        super().__init__('talker')
        self.publisher_ = self.create_publisher(String, 'weather_topic', 10)
        self.timer = self.create_timer(2.0, self.publish_weather)  # 2秒ごとにメッセージを送信

    def publish_weather(self):
        weather_options = ["晴れ", "雨", "曇り", "雪", "強風"]
        current_weather = random.choice(weather_options)
        msg = String()
        msg.data = current_weather
        self.publisher_.publish(msg)
        self.get_logger().info(f'[Talker] Published: "{msg.data}"')

def main(args=None):
    rclpy.init(args=args)
    talker = Talker()
    rclpy.spin(talker)
    talker.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
