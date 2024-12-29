import rclpy
from rclpy.node import Node
from std_msgs.msg import String

class Listener(Node):
    def __init__(self):
        super().__init__('listener')
        self.subscription = self.create_subscription(
            String,
            'weather_topic',
            self.listener_callback,
            10)
        self.publisher_ = self.create_publisher(String, 'reaction_topic', 10)

    def listener_callback(self, msg):
        weather = msg.data
        self.get_logger().info(f'[Listener] Received: "{weather}"')
       
        reaction_msg = String()
        if weather == "晴れ":
            reaction_msg.data = "Listener: いい天気ですね！"
        elif weather == "雨":
            reaction_msg.data = "Listener: 雨なので傘を忘れずに！"
        elif weather == "曇り":
            reaction_msg.data = "Listener: 曇りの日は涼しいですね。"
        elif weather == "雪":
            reaction_msg.data = "Listener: 雪が降っています！暖かくして過ごしましょう。"
        elif weather == "強風":
            reaction_msg.data = "Listener: 強風なのでお気をつけください！"
        else:
            reaction_msg.data = "Listener: 未知の天気情報です！"
       
        self.publisher_.publish(reaction_msg)
        self.get_logger().info(f'[Listener] Published Reaction: "{reaction_msg.data}"')

def main(args=None):
    rclpy.init(args=args)
    listener = Listener()
    rclpy.spin(listener)
    listener.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
