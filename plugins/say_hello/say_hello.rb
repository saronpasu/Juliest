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

# プラグインの定義
class Say_Hello < Juliest::Plugin::Base

  # 初期化
  def initialize(user_data, activate_persona)
    @user_data = user_data
    @activate_persona = activate_persona

    # プラグインの名称
    @plugin_name = 'say_hello'
    # プラグインバージョン
    @version = '0.0.1'
    # プラグインの製作者
    @creator = 'saronpasu'
    # 製作者への連絡方法
    @contact = 'https://twitter.com/saronpasu'
    # ライセンス
    @license = "ruby's license"
    # 依存ライブラリ、ミドルウェア、ネイティブコマンド等
    @requirement = {
      # ライブラリに依存しない
      :library => false,
      # ペルソナのサポートに依存しない
      :persona_support => false,
      # 引数を必要としない
      :arguments => false,
      # 確認を必要としない
      :confirm => false,
      # 待機を必要としない
      :wait => false,
      # ネイティブ機能を必要としない
      :native_command => false
    }
  end

  # コマンドパターンマッチの生成
  def generate_command_pattern
    Regexp.new(plugin_data[:pattern])
  end
  

  # 実行処理 ここからがプラグイン独自のメイン処理
  def call(args = nil)

    # 初期の応答分
    hello_message = "こんにちは"

    # PCの時計から現在時刻を判断
    now = Time.now
    morning = Range.new(5,10)
    noonish = Range.new(11,15)
    case now.hour
      # 朝なら「おはよう」と返す
      when morning
        hello_message = "おはよう"
      # 昼なら「こんにちは」と返す
      when noonish
        hello_message = "こんにちわ"
      # 朝、昼以外なら「こんばんは」と返す
      else
        hello_message = "こんばんわ"
    end

    # 音声再生を行う
    @juliest.play_voice(hello_message.to_msgpack)
  end
end

