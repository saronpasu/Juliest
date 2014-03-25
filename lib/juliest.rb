require 'julius'
require 'msgpack'

class Juliest
  attr_accessor(
    :mode,
    :personas,
    :plugins
  )

  def initialize
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
    command_patterns = plugins.map.do |plugin|
      {plugin.name => generate_command_parser(plugin.command_pattern)}
    end
    
    command = nil
    argments = nil
    
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
        # コマンドが認識できた場合、コマンドを実行する
        execute_plugin_command
      else
        # コマンドが認識できなかった場合、メッセージ再生のみを行う
        generate_persona_message
        play_voice
      end
    end
    
  end

  # プラグインコマンドを実行する
  def execute_plugin_command
  end

  # 仮想人格のメッセージ生成
  def generate_persona_message
  end

  # 音声再生
  def play_voice
  end

end

