require 'julius'
require 'msgpack'

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
    :user_data
  )
  
  # 初期設定:AquesTalk2 サーブレットへの応答待機時間(秒)
  DEFAULT_AQUESTALK2_WAIT_SEC = 2
  # 初期設定:活性化している仮想人格
  DEFAULT_ACTIVATE_PERSONA = 'est'
  # 初期設定:設定ファイルのパス
  # DEFAULT_USER_DATA_PATH = '~/.juliest/config.yaml'
  DEFAULT_CONFIG_PATH = './config.yaml'
  # 初期設定：ユーザデータのパス
  # DEFAULT_USER_DATA_PATH = '~/.juliest/data/user_data.yaml'
  DEFAULT_USER_DATA_PATH = './data/user_data.yaml'

  # プラグインのパス
  PLUGINS_PATH = './plugins/'
  # 仮想人格のパス
  PERSONA_PATH = './persona/'
  
  # config.yaml のロード
  def load_config
  end

  # data/user_data.yaml のロード
  def load_user_data
  end

  # 仮想人格リストのロード
  def load_persona
    list = @config[:persona]
    result = Array.allocate
    list.each do |persona|
      # 仮想人格の個別ロード
    end
    return result
  end

  # プラグインリストのロード
  def load_plugins
    list = @config[:plugins]
    result = Array.allocate
    list.each do |plugin|
      # プラグインの個別ロード
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
  def generate_command_parser
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
    mode_command_pattern = generate_mode_command_parser
    persona_call_pattern = generate_persona_call_parser
    command_patterns = plugins.map do |plugin|
      {plugin.name => generate_command_parser(plugin.command_pattern)}
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
      when mode_command_pattern
      # 仮想人格が呼ばれた場合
      when persona_call_pattern

        # プラグイン毎にパースし、呼び出されたコマンドを選択する
        command = command_patterns.find do |command|
          command[:pattern].match(input)
        end

      if command then
        # コマンドが認識できた場合、確認メッセージの再生を行う
        result = plugin_confirm_message(command)
        if result then
          # 確認メッセージが認証できた場合、コマンドを実行する
          execute_plugin_command
        else
          # 確認メッセージが認証できない場合、再入力を願い出る
          re_input_message
        end
      else
        # コマンドが認識できなかった場合、メッセージ再生のみを行う
        re_input_message

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
  def execute_plugin_command
  end

  # 仮想人格のメッセージ生成(array to array)
  def generate_persona_messages(source)
    
  end

  # 音声再生
  def play_voice(message, wait_sec = nil)
    # AquesTalk2 サーブレットのステータスを確認
    # 無応答または、 :running 以外の場合は待機してリトライ。 Kernel#sleep(sec) を使用する。
  end

  # POST 呼び出しを受けた際の処理
  def main(message)

    # 対話モード
    #   プラグインコマンドチェック
    #   true -> 確認
    #   false -> 聞き返し
    # 名前呼び出しチェック
    #   true -> 対話モード
    #   false -> 何もしない

  end

  # PUT 呼び出しを受けた際の処理
  def status_change(message)
  end

end

