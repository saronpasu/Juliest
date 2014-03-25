require 'julius'
require 'msgpack'

# プラグインのベースクラス。各種プラグインはこのクラスを継承すること。
class Juliest::Plugin::Base

  attr_accessor(
    # プラグインバージョン
    :version,
    # プラグインの製作者
    :creator,
    # 製作者への連絡方法
    :contact,
    # ライセンス
    :license,
    # 依存ライブラリ、ミドルウェア、ネイティブコマンド等
    :requirement
  )

  # 初期化
  def initialize
  end

  # このプラグインはペルソナによる対応が必須であるか
  def require_persona_support?
  end

  # このプラグインは引数の要求を必要とするか
  def require_arguments?
  end

  # このプラグインは確認メッセージを必要とするか
  def require_confirm?
  end

  # このプラグインは待機メッセージを必要とするか
  def require_wait?
  end

  # このプラグインはネイティブコマンドを必要とするか
  def require_native_command?
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

end

# プラグイン管理クラス
class Juliest::PluginManager
  # 読み込まれているプラグインの一覧
  attr_accessor :plugins

  # 初期化
  def initialize
  end

  # プラグインの読み込み
  def load_plugin
  end

  # プラグインを一覧へ追加
  def add_plugin
  end

  # プラグインを一覧から削除
  def remove_plugin
  end

  # プラグインがペルソナにサポートされているかどうか
  def persona_support?(persona, plugin)
  end

end


