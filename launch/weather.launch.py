import launch
import launch.actions
import launch.substitutions
import launch_ros.actions

def generate_launch_description():

    # weather_reporter.py を起動するノードを設定
    weather_reporter = launch_ros.actions.Node(
        package='mypkg',
        executable='weather_reporter',  # 実行するファイル名 (ros2 run mypkg weather_reporter で実行される)
        output='screen',  # 標準出力にログを表示
        parameters=[{'use_sim_time': False}]
    )

    return launch.LaunchDescription([weather_reporter])
