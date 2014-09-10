require 'julius'
require 'msgpack'
require 'net/http'
require 'uri'

class Juliest
  attr_accessor(
    # Juliest サーブレットモード
    :mode,
    # Juliest 読み込み済み仮想人格リスト
    :persona,
    # 活性化している仮想人格
    :active_persona,
    # Juliest 読み込み済みプラグインリスト
    :plugins,
    # AqeusTalk2 サーブレットへの通信待機時間(秒)
    :aquestalk2_wait_sec,
    # 設定データ
    :config,
    # ユーザデータ
    :user_data,
    # パーサの共通ワード
    :parser_common_words,
    # AquesTalk2
    :aquestalk2,
    # Juliest
    :juliest,
    # base path
    :base_path
  )
  
  # 初期設定:AquesTalk2 サーブレットへの応答待機時間(秒)
  DEFAULT_AQUESTALK2_WAIT_SEC = 0.5
  # 初期設定:活性化している仮想人格
  DEFAULT_ACTIVATE_PERSONA = 'est'
  # 初期設定:設定ファイルのパス
  # DEFAULT_USER_DATA_PATH = '~/.juliest/config.yaml'
  DEFAULT_CONFIG_PATH = './config.yaml'
  # 初期設定：ユーザデータのパス
  # DEFAULT_USER_DATA_PATH = '~/.juliest/data/user_data.yaml'
  DEFAULT_USER_DATA_PATH = './data/user_data.yaml'

  # パーサー用共通ワードのパス
  PARSER_COMMON_WORDS_PATH = './parser/common_words.yaml'

  # プラグインのパス
  PLUGINS_PATH = './plugins/'
  # 仮想人格のパス
  PERSONA_PATH = './persona/'
  
  # config.yaml のロード
  def load_config(path = DEFAULT_CONFIG_PATH)
    @config = open(path, 'r'){|f|YAML::load(f.read)}
  end

  # data/user_data.yaml のロード
  def load_user_data(path = DEFAULT_USER_DATA)
    @user_data = open(path, 'r'){|f|YAML::load(f.read)}
  end

  # parser/common_words.yaml のロード
  def load_parser_common_words(path = PARSER_COMMON_WORDS_PATH)
    # @parser_common_words = open(path, 'r'){|f|YAML::load(f.read)}
  end

  # 仮想人格リストのロード
  def load_persona
    list = @config[:persona]
    result = Array.allocate
    list.each do |persona|
      # 仮想人格の個別ロード
      persona_data = Hash.allocate
      open(PERSONA_PATH + persona.to_s + '/persona.yaml', 'r'){|f|
        persona_data[persona] = {:persona => YAML::load(f.read)}
      }
      open(PERSONA_PATH + persona.to_s + '/word.yaml', 'r'){|f|
        persona_data[persona] = {:word => YAML::load(f.read)}
      }
      result.push(persona_data)
    end
    return result
  end

  # プラグインリストのロード
  def load_plugins
    list = @config[:plugins]
    result = Array.allocate
    list.each do |plugin|
      # プラグインの個別ロード
      load(PLUGINS_PATH + plugin.to_s + '/' + plugin.to_s + '.rb')
      plugin_data = nil
      open(PLUGINS_PATH + plugin.to_s + '.yaml', 'r'){|f|
        plugin_data = YAML::load(f.read)
      }
      result.push(
        plugin_data
      )
    end
    return result
  end

  # 初期化処理
  def initialize(
    activate_persona = nil,
    config = nil,
    user_data = nil
  )
    config ||= DEFAULT_CONFIG_PATH
    user_data ||= DEFAULT_USER_DATA_PATH
    activate_persona ||= DEFAULT_ACTIVATE_PERSONA
    @config = load_config(config)
    @user_data ||= load_user_data(user_data)
    @aquestalk2_wait_sec ||= DEFAULT_AQUESTALK2_WAIT_SEC
    @persona ||= load_persona
    @plugins ||= load_plugins
    @activate_persona ||= activate_persona

    base_path ||= @config[:base_path]
    base_path ||= 'juliest'
    @aquestalk2 ||= @config[:aquestalk2]
    @julius ||= @config[:julius]
    @juliest ||= @config[:juliest]
    @base_path = base_path
  end

  # モード変更用のパーサ生成
  def generate_mode_command_parser
  end

  # 仮想人格コール用のパーサ生成
  def generate_name_call_parser
  end

  # 対話モードのパーサ生成(プラグインからの呼び出し)
  def generate_dialog_parser
  end

  # コマンドパーサを生成(プラグイン毎)
  def generate_command_parser(pattern)
    Regexp.new(pattern)
  end

  # モードコマンドをパースする
  def parse_mode_command
  end

  # 仮想人格のコールをパースする
  def parse_name_call
  end

  # 対話モードの引数をパースする
  def parse_dialog_argment
  end

  # コマンドをパースする(プラグイン毎)
  def parse_command
  end

  # 条件ごとにパースを行う(パーサのメイン処理)
  def parse(input)
    # mode_command_pattern = generate_mode_command_parser
    # persona_call_pattern = generate_persona_call_parser
    command_patterns = @plugins.map do |plugin|
      {
         :pattern => generate_command_parser(plugin[:pattern]),
         :class => plugin[:class]
      }
    end
    
    command = nil
    argments = nil
    messages = nil

    # モードによる処理分岐
    case @mode
      # サイレントモード時にはモード切替のみ受信
      when :silent
        
      # 対話モード時には引数受信の処理を行う
      when :dialog
        
    end
    
    # 通常処理
    case input
      # モード切り替え(優先処理)
      # when mode_command_pattern
      # 仮想人格が呼ばれた場合
      # when persona_call_pattern
      when nil
      else
        # プラグイン毎にパースし、呼び出されたコマンドを選択する
        command = command_patterns.find do |command|
          command[:pattern].match(input)
        end

      if command then
        # コマンドを実行する
        execute_plugin_command(command[:class])
      end

    end
  end

  def re_input_message
    source = [
      ":__prefix_ask_to__",
      ":__ask_to__",
      ":__suffix_ask_to__",
      ":__prefix_re_input__",
      ":__re_input__",
      ":__suffix_re_input__"
    ]
    messages = generate_persona_messages(source)
    messages.compact.uniq!

    messages.each do |message|
      play_voice(message)
    end

  end

  def plugin_confirm_message(plugin)
  end

  # プラグインコマンドを実行する
  def execute_plugin_command(class_name)
    plugin = eval("#{class_name}.new(@user_data, @activate_persona)")
    plugin.juliest = self.clone
    plugin.call
  end

  # 仮想人格のメッセージ生成(array to array)
  def generate_persona_messages(source)
    
  end

  # Juliest サーブレットへの PUT 実行
  def put_juliest(message)
    
    host = '127.0.0.1'
    base_path = @juliest[:base_path]
    port = @juliest[:port]
    uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Put.new(uri.request_uri)
    request.body= message
    response = Net::HTTP.start(host, port){|http|
      http.request(request)
    }
    
    return response
  end

  # AquesTalk2 サーブレットへの POST 実行
  def post_aquestalk2(message)
    # @status = :relational
    put_juliest(:relational.to_msgpack)
    
    host = '127.0.0.1'
    base_path = @aquestalk2[:base_path]
    port = @aquestalk2[:port]
    uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body= message
    response = Net::HTTP.start(host, port){|http|
      http.request(request)
    }
    
    # @status = :running
    put_juliest(:running.to_msgpack)
    return response
  end

  # AquesTalk2 サーブレットへの GET 実行
  def get_aquestalk2
    # @status = :relational
    put_juliest(:relational.to_msgpack)
    
    host = '127.0.0.1'
    base_path = @aquestalk2[:base_path]
    port = @aquestalk2[:port]
    uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(host, port){|http|
      http.request(request)
    }
    
    # @status = :running
    put_juliest(:running.to_msgpack)
    return response
  end

  # Julius サーブレットへの PUT 実行
  def put_julius(message)
    # @status = :relational
    put_juliest(:relational.to_msgpack)
    
    host = '127.0.0.1'
    base_path = @julius[:base_path]
    port = @julius[:port]
    uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Put.new(uri.request_uri)
    request.body= message
    response = Net::HTTP.start(host, port){|http|
      http.request(request)
    }
    
    # @status = :running
    put_juliest(:running.to_msgpack)
    return response
  end

  # Julius サーブレットへの GET 実行
  def get_julius
    # @status = :relational
    put_juliest(:relational.to_msgpack)
    
    host = '127.0.0.1'
    base_path = @julius[:base_path]
    port = @julius[:port]
    uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(host, port){|http|
      http.request(request)
    }
    
    # @status = :running
    put_juliest(:running.to_msgpack)
    return response
  end

  # 音声再生
  def play_voice(message, wait_sec = @aquestalk2_wait_sec)
    # AquesTalk2 サーブレットのステータスを確認
    # 無応答または、 :running 以外の場合は待機してリトライ。 Kernel#sleep(sec) を使用する。
    # count 回数待機して、:running 以外の場合は処理をキャンセル
    status = nil
    count = 6
    while status != :running do 
      response = get_aquestalk2
      status = MessagePack.unpack(response.body).to_sym
      sleep wait_sec
p status
p count
      count -= 1
      exit if count.zero?
      break if status == :running
    end
    response = post_aquestalk2(message)
    return MessagePack.unpack(response.body)
  end

  # POST 呼び出しを受けた際の処理
  def main(message)

#p :__juliest_main__
    input = MessagePack.unpack(message)
    parse(input[1...-1])

  end

  # PUT 呼び出しを受けた際の処理
  def status_change(message)
    put_juliest(message)
  end

end

