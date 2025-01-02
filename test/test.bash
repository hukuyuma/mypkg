#!/bin/bash

# デフォルトディレクトリ設定
dir=~
[ "$1" != "" ] && dir="$1"

# ROS 2 ワークスペースのビルド
cd $dir/ros2_ws
colcon build
source $dir/.bashrc

# ノードを15秒間実行してログを取得
timeout 15 ros2 launch mypkg talk_listen.launch.py > /tmp/mypkg.log &

# 8秒間待機して強風メッセージを確認
sleep 8

# メッセージセットと時間間隔を確認
previous_time=0
expected_order=("いい天気です！外出を楽しんでください。" "雨が降っています。傘を忘れずに！" "曇り空です。過ごしやすい一日になりそうです。" "雪が降っています。暖かくして安全に過ごしてください。" "強風が吹いています。外出には注意してください！")
message_counter=0
interval_check=true
order_check=true

# ログファイルの中身を読み取る
while read -r line; do
    if [[ "$line" =~ "Publishing: " ]]; then
        # メッセージを抽出
        message=$(echo "$line" | sed 's/.*Publishing: "\(.*\)"/\1/')
       
        # 期待されるメッセージと一致するか確認
        if [ "$message" == "${expected_order[$message_counter]}" ]; then
            # 正しい順番であれば次のメッセージへ
            message_counter=$((message_counter+1))
        else
            order_check=false
            break
        fi
       
        # タイムスタンプを抽出 (ログの形式に応じて調整)
        timestamp=$(echo "$line" | grep -oP '\[\d+\.\d+\]' | tr -d '[]')
        timestamp_int=${timestamp%.*}
       
        # 最初のタイムスタンプを保存
        if [ $previous_time -eq 0 ]; then
            previous_time=$timestamp_int
            continue
        fi
       
        # 時間差を計算
        interval=$((timestamp_int - previous_time))
       
        # 時間差が2秒かどうかを確認
        if [ $interval -ne 2 ]; then
            interval_check=false
            break
        fi
       
        previous_time=$timestamp_int
    fi
done < /tmp/mypkg.log

# 順番と時間間隔の結果を報告
if [ "$order_check" = true ] && [ "$interval_check" = true ]; then
    echo "テスト成功: メッセージは順番通りに、2秒ごとに受信されました。"
else
    if [ "$order_check" = false ]; then
        echo "テスト失敗: メッセージセットが順番通りに受信されませんでした。"
    fi
    if [ "$interval_check" = false ]; then
        echo "テスト失敗: メッセージ間隔が2秒ではありません。"
    fi
fi
