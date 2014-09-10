require 'juliest/plugin'
require 'yaml'
require 'time'
require 'msgpack'

# 設定の読み込み
PLUGINS_PATH = 'plugins'
plugin_data = nil
open(PLUGINS_PATH + '/say_hello.yaml', 'r'){|f|
  plugin_data = YAML::load(f.read)
}

class Say_Hello < Juliest::Plugin::Base
  # プラグインバージョン
  @version = '0.0.1',
  # プラグインの製作者
  @creator = 'saronpasu',
  # 製作者への連絡方法
  @contact = 'https://twitter.com/saronpasu',
  # ライセンス
  @license = 'none',
  # 依存ライブラリ、ミドルウェア、ネイティブコマンド等
  @requirement = {
    :library => false,
    :persona_support => false,
    :arguments => false,
    :confirm => false,
    :wait => false,
    :native_command => false
  }

  # コマンドパターンマッチの生成
  def generate_command_pattern
    Regexp.new(plugin_data[:pattern])
  end
  
  # 実行処理
  def call(args = nil)
    hello_message = "こんにちは"
    now = Time.now
    morning = Range.new(5,10)
    noonish = Range.new(11,15)
    case now.hour
      when morning
        hello_message = "おはよう"
      when noonish
        hello_message = "こんにちわ"
      else
        hello_message = "こんばんわ"
    end
    @juliest.play_voice(hello_message.to_msgpack)
  end
end

