require 'julius'
require 'msgpack'

class Juliest::Plugin; end

# プラグインのベースクラス。各種プラグインはこのクラスを継承すること。
class Juliest::Plugin::Base

  attr_accessor(
    # プラグインの名称
    :plugin_name,
    # プラグインバージョン
    :version,
    # プラグインの製作者
    :creator,
    # 製作者への連絡方法
    :contact,
    # ライセンス
    :license,
    # 依存ライブラリ、ミドルウェア、ネイティブコマンド等
    :requirement,
    # ユーザデータ(Juliestより受け取る)
    :user_data,
    # 仮想人格データ(Juliestより受け取る)
    :activate_persona,
    # Juliest インスタンス
    :juliest
  )

  # 初期化
  def initialize(user_data, activate_persona)
    @user_data = user_data
    @activate_persona = activate_persona
  end

  # このプラグインはペルソナによる対応が必須であるか
  def require_persona_support?
    @requirement[:persona_support]
  end

  # このプラグインをペルソナはサポートしているか
  def persona_supported?
    persona = @juliest.get_activate_persona
    result = nil
    result = persona[:persona][:persona][:support_plugins].find do |plugin|
      @plugin_name.eql?(plugin)
    end
    return !!result
  end

  # このプラグインは引数の要求を必要とするか
  def require_arguments?
    @requirement[:arguments]
  end

  # このプラグインは確認メッセージを必要とするか
  def require_confirm?
    @requirement[:confirm]
  end

  # このプラグインは待機メッセージを必要とするか
  def require_wait?
   @requirement[:wait]
  end

  # このプラグインはネイティブコマンドを必要とするか
  def require_native_command?
   @requirement[:native_command]
  end

  # エラーメッセージの生成
  def generate_error_message
  end

  # コマンドパターンマッチの生成
  def generate_command_pattern
  end

  # 引数パターンマッチの生成
  def generate_argument_pattern
  end

  # 確認メッセージの生成
  def generate_confirm_pattern
  end

  # 待機メッセージの生成
  def generate_wait_message
  end

  # 継承したクラスで実装して下さい
  def call(args = nil)
  end
end

# プラグイン管理クラス
class Juliest::PluginManager
  # プラグインのパス
  PLUGINS_PATH = './plugins/'
  # 仮想人格のパス
  PERSONA_PATH = './persona/'

  # 読み込まれているプラグインの一覧
  attr_accessor :plugins

  # 初期化
  def initialize
  end

  # プラグインの読み込み
  def load_plugin(plugin)
    load(PLUGINS_PATH + '/' + plugin + '.rb')
  end

  # プラグインを一覧へ追加
  def add_plugin(plugin)
    
  end

  # プラグインを一覧から削除
  def remove_plugin(plugin)
    
  end

  # プラグインがペルソナにサポートされているかどうか
  def persona_support?(persona, plugin)
  end

end


