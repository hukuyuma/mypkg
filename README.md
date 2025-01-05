# weather_reporter

![test](https://github.com/hukuyuma/mypkg/actions/workflows/test.yml/badge.svg)

weather_reporterはRos2ノードで５つの天気に対するメッセージを２秒ごとにパブリッシュする。

## ノード

- **weather_reporter**
  - ５つの天気に対するメッセージをトピックにパブリッシュするノード

## 概要

weather_reporterは以下のメッセージをパブリッシュします.

• いい天気です！外出を楽しんでください。

• 雨が降っています。傘を忘れずに！

• 曇り空です。過ごしやすい一日になりそうです。

• 雪が降っています。暖かくして安全に過ごしてください。

• 強風が吹いています。外出には注意してください！

## 使用方法

1. ノードの起動

ros2 run mypkg weather_reporter

2. トピックの確認

別端末にて以下を実行して、トピックのデータを確認する。

ros2 topic echo /weather_advice_topic

実行例

data: いい天気です！外出を楽しんでください。
---
data: 雨が降っています。傘を忘れずに！
---
data: 曇り空です。過ごしやすい一日になりそうです。
---
data: 雪が降っています。暖かくして安全に過ごしてください。
---
data: 強風が吹いています。外出には注意してください！
---
data: いい天気です！外出を楽しんでください。
---
data: 雨が降っています。傘を忘れずに！
---
```
