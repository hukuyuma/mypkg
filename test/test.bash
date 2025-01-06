#!/bin/bash
# SPDX-FileCopyrightText: 2024 Yuma Fukuya
# SPDX-License-Identifier: BSD-3-Clause

# デフォルトディレクトリ設定
dir=~
[ "$1" != "" ] && dir="$1"

# ROS 2 ワークスペースのビルド
cd $dir/ros2_ws
colcon build
source $dir/.bashrc

# ノードを15秒間実行
timeout 15 ros2 launch mypkg weather.launch.py &

# トピックの出力を取得
sleep 2  # ノードの起動を待つ
timeout 10 ros2 topic echo /weather_advice_topic > /tmp/mypkg_topic.log &

# 10秒間待機してトピックデータを収集
sleep 10

# トピックデータを確認
expected_order=("いい天気です！外出を楽しんでください。" "雨が降っています。傘を忘れずに！" "曇り空です。過ごしやすい一日になりそうです。" "雪が降っています。暖かくして安全に過ごしてください。" "強風が吹いています。外出には注意してください！")
message_counter=0
order_check=true

# トピックログファイルの中身を読み取る
while read -r line; do
    # メッセージを抽出
    if [[ "$line" =~ "data:" ]]; then
        message=$(echo "$line" | sed 's/data: //g')

        # 期待されるメッセージと一致するか確認
        if [ "$message" == "${expected_order[$message_counter]}" ]; then
            # 正しい順番であれば次のメッセージへ
            message_counter=$((message_counter+1))
        else
            order_check=false
            break
        fi
    fi
done < /tmp/mypkg_topic.log

# テスト結果の表示
if $order_check; then
    echo "テスト成功: メッセージは順番通りに受信されました。"
else
    echo "テスト失敗: メッセージが順番通りに受信されませんでした。"
fi
