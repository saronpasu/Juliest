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
class Ask_Aboutme < Juliest::Plugin::Base

  # 初期化
  def initialize(user_data, activate_persona)
    @user_data = user_data
    @activate_persona = activate_persona

    # プラグインの名称
    @plugin_name = 'ask_aboutme'
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
      # ペルソナのサポートに依存する
      :persona_support => true,
      # 引数を必要としない
      :arguments => false,
      # 確認を必要とする
      :confirm => true,
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
    # ペルソナがサポートしているかどうか確認
    # 未サポートの場合は処理を中止する
    unless persona_supported? then
      # ペルソナが非対応
      return false
    end

    # 自己紹介のテキストをロード
    persona = @juliest.get_activate_persona
    sources = persona[:word][:plugins]["ask_aboutme"]


    # 自己紹介を実行
    message = "自己紹介をします。"
    @juliest.play_voice(message.to_msgpack)
    sources.each do |source|
      @juliest.play_voice(source.to_msgpack)
    end
    message = "自己紹介を終わります。"
    @juliest.play_voice(message.to_msgpack)
    @juliest.confirm_flag = nil
  end
end

