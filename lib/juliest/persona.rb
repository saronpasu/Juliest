require 'julius'

# エラークラス
class Julius::Persorna::PersonaError < StandardError; end

# ベースクラス
class Julius::Persona::Base

  PERSONA_PATH = './persona/'

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
    :support_pluigns,
    # 登録単語リスト
    :word,
    # AqKanji2Koe インスタンス
    :aqk2k
  )

  # 初期化
  def initialize(persona)
    persona = load_persona(persona)
    @version = persona[:version]
    @name = persona[:name]
    @creator = persona[:creator]
    @contact = persona[:contact]
    @about = persona[:about]
    @copylight = perosna[:copylight]
    @support_plugins = persona[:support_plugins]
    @word = load_word(persona)
    @aqk2k = AqKanji2Koe.new
  end

  # 単語リストの読み込み
  def load_word(persona)
    result = nil
    open(PERSONA_PATH+persona+'/word.yaml', 'r'){|f|result = YAML::load(f.read)}
    return result
  end

  # 仮想人格の読み込み
  def load_persona(persona)
    result = nil
    open(PERSONA_PATH+persona+'/persona.yaml', 'r'){|f|result = YAML::load(f.read)[:persona]}
    return result
  end
  
end

# 仮想人格クラス
class Julius::Persona < Julius::Persona::Base

  # 名前一致パーサ生成
  def generate_name_parser
    source = '/('+@word[:persona_name].join('|')+')/'
    reg = Regexp.new(source)
    return reg
  end

  # メッセージ生成
  def generate_message(source)
    result = source
    @word[:word].each do |pattern, message|
      if message.is_a? Array then
        message = rand_choice(message)
      end
      result.gsub!(pattern, message)
    end
    return result
  end

  # メッセージ送信
  def send_message
  end

  # メッセージ受信
  def input_message
  end

  # ランダム選択(有限長Array)
  def rand_choice(word)
    result = nil
    
    # RUBY バージョンで分岐
    case RUBY_VERSION
      when /1\.\d/
        result = word[rand(word.size)]
      when /2\.\d/
        result = word.sample
    end
    
    return result
  end

  # ランダム選択が必要かどうか
  def is_choice?(word)
  end

end

