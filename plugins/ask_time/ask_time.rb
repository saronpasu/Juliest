require 'juliest/plugin'
require 'yaml'
require 'time'
require 'msgpack'

# 設定の読み込み
plugins_path = 'plugins'
plugin_data = nil
open(plugins_path + '/say_hello.yaml', 'r'){|f|
  plugin_data = YAML::load(f.read)
}

# プラグインの定義
class Ask_Time < Juliest::Plugin::Base

  # 初期化
  def initialize(user_data, activate_persona)
    @user_data = user_data
    @activate_persona = activate_persona

    # プラグインの名称
    @plugin_name = 'ask_time'
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
    now = Time.now
    hour = now.hour.to_s
    min = now.min.to_s
    sec = now.sec.to_s
    message = "現在の時刻は、#{hour}時#{min}分#{sec}秒です。"

    # 音声再生を行う
    @juliest.play_voice(message.to_msgpack)
  end
end

