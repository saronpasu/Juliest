require 'julius'

# エラークラス
class Julius::Persorna::PersonaError < StandardError; end

# ベースクラス
class Julius::Persona::Base

  attr_accessor(
    # 仮想人格のバージョン
    :version,
    # 仮想人格の名前
    :name,
    # 仮想人格の製作者
    :creator,
    # 製作者の連絡先
    :contact,
    # 概要
    :about,
    # ライセンス
    :license,
    # コピーライト(著作権表示)
    :copylight,
    # 対応プラグイン(Array)
    :support_pluigns
  )

  # 初期化
  def initialize
  end

  # 仮想人格の読み込み
  def load_persona
  end
  
end

# 仮想人格クラス
class Julius::Persona < Julius::Persona::Base

  # 活性化
  def activate_persona
  end

  # 非活性化
  def deactivate_persona
  end

  # 切り替え
  def change_persona
  end

  # メッセージ生成
  def generate_message
  end

  # メッセージ送信
  def send_message
  end

  # メッセージ受信
  def input_message
  end

  # ランダム選択(有限長Array)
  def rand_choice
  end

  # ランダム選択が必要かどうか
  def is_choice?
  end

end

