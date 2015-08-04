sensors
---

`lm_sensors`を用いてCPU温度などを取得する`mackerel`用カスタムメトリックです。

## 事前準備

`lm_sensors`を導入します。例えば`CentOS6`の場合:

~~~
yum install lm_sensors
~~~

## 使い方

### エージェント設定ファイルの編集

`mackerel`のエージェント設定ファイル(デフォルトでは`/etc/mackerel-agent/mackerel-agent.conf`)にプラグインを追加します。

~~~
[plugin.metrics.sensors]
command = "ruby /path/to/mackerel-plugin-sensors/temperature-metrics.rb"
~~~

- `ruby`などはエージェント動作時に正しくパスが通っているかを確認しましょう。

反映にはエージェントの再起動が必要です。

## 注意点

現状では温度のみ取得します。(検証環境に温度センサしかついていないため)

![sample](http://i.gyazo.com/dab14d092604e122b7ee8456be2d3241.png)
