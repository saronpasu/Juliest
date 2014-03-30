#-*- encoding: utf-8 -*-


class AquesTalk2::Servlet
  autoload :AquesTalk2, 'aquestalk2'
  autoload :AqKanji2Koe, 'aqkanji2koe'
  autoload :YAML, 'yaml'
  autoload :FileUtils, 'fileutils'

  require 'uri'
  require 'net/http'

  
  class VERSION
    MAJOR = 0
    MINOR = 0
    TINY = 1
    
    def self.to_s
      [MAJOR, MINOR, TINY].join('.')
    end
    def self.inspect
      [MAJOR, MINOR, TINY].join('.')
    end
  end
  
  # サーブレットのベースクラス
  class Base
    autoload :Logger, 'logger'
    CONFIG_FILE = 'config.yaml'
    LOG_DIR = 'log'
    SOUND_RESOURCE_DIR = 'resource/voice'
    
    attr_accessor :config,
      :aquestalk2,
      :aqkanji2koe,
      :base_path,
      :player,
      :player_args,
      :status,
      :port,
      :log
    
    def initialize
      open(CONFIG_FILE, 'r'){|f|@config = YAML::load(f.read)[:aquestalk2]}
      # ログ出力設定の初期化
      if FileTest.exist?(LOG_DIR) then
        file = LOG_DIR+'/aquestalk2_servlet.log'
        shift_age = 7
        shift_size = 10*1024*1024
        @log = Logger.new(file, shift_age, shift_size)
        @log.level = Logger::ERROR
      else
        @log = Logger.new(STDERR)
        @log.level = Logger::ERROR
      end
      # サーブレットのポート設定
      port ||= @config[:port]
      port ||= 9292
      @port = port
      # サーブレットのパス設定
      base_path ||= @config[:base_path]
      base_path ||= 'aquestalk2'
      @base_path = base_path
      # CUI 音楽プレイヤーの設定
      @player ||= @config[:player]
      # AquesTalk2 インスタンスの生成
      @aquestalk2 = AquesTalk2.new
      # AqKanji2Koe インスタンスの生成
      @aqkanji2koe = AqKanji2Koe.new
      # サーブレットのステータス設定
      @status ||= :running
    end

    # AquesTalk2 の実行
    def synthe(input)
      @status = :synthe
  
      source = MessagePack.unpack(input)
      source = source[3...-1]
      uid = source.object_id
      source = @aqkanji2koe.convert(source)
      output = SOUND_RESOURCE_DIR+'/output-'+uid.to_s+'.wav'
      @aquestalk2.synthe(source, output)

      @status = :running
      return output
    end

    # CUI音楽プレイヤーで再生
    def play_sound(input)
      @status = :play_sound

      commands = ''
      commands += @player + ' '
      commands += @player_args if @player_args
      commands += input
      `#{commands}`
      FileUtils.remove input if FileTest.exist?(input)

      @status = :runnning
    end

    # Julius サーブレットへのステータス変更信号の送信
    def put_status_to_julius(status)
      julius = nil
      open(CONFIG_FILE, 'r'){|f|julius = YAML::load(f.read)[:julius]}

      host = '127.0.0.1'
      base_path = julius[:base_path]
      port = julius[:port]
      uri = URI.parse('http://'+host+'/'+base_path)
      request = Net::HTTP::Put.new(uri.request_uri)
      request.body= status
      response = Net::HTTP.start(host, port){|http|
        http.request(request)
      }
    end
  end
  
  # サーブレットクラス
  class App < Base
    require 'rack'
    require 'msgpack'
    
    def call(env)
      request = Rack::Request.new(env)

      # レスポンスの初期化
      status = 200
      header = {}
      body = []
      result = nil
      
      # サーブレットのパス以外へのアクセスは弾く
      unless request.path.match(@base_path)
        status = 404
        body<< 'bad request'.to_msgpack
      end
      
      case
        # GETメソッドの場合、サーブレットのステータスを返す
        when request.get?
          body<< @status.to_msgpack

        # PUT メソッドの場合、サーブレットのステータスを変更する
        when request.put?
          @status = MessagePack.unpack(request.body)
          body<< true.to_msgpack

        # POST メソッドの場合、かつ。 サーブレットのステータスがサイレントモードの場合は
        # POST メソッドによる命令実行は行わない。
        when request.post? && @status.eql?(:silent)
          status = 503
          body<< @status.to_msgpack

        # POST メソッドの場合、 Aqestalk2による音声合成と、CUI音楽プレイヤーによる再生を実行
        when request.post?
          
          put_status_to_julius('silent')
          input = request.body
          voice = synthe(input)
          play_sound(voice)
          put_status_to_julius('running')
          
          body<< true.to_msgpack
      end
      
      # レスポンスを返す
      header = Rack::Utils::HeaderHash.new(header)
      res = Rack::Response.new(body, status, header)
      res.finish
    end
  end
end

