#-*- encoding: utf-8 -*-
require 'net/http'
require 'uri'

class Julius::Servlet
  autoload :YAML, 'yaml'
  
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
    
    attr_accessor :config,
      :base_path,
      :status,
      :port,
      :juliest,
      :log
    
    def initialize
      # 設定ファイルの読み込み
      open(CONFIG_FILE, 'r'){|f|@config = YAML::load(f.read)[:julius]}
      # ログの初期化
      if FileTest.exist?(LOG_DIR) then
        file = LOG_DIR+'/julius_servlet.log'
        shift_age = 7
        shift_size = 10*1024*1024
        @log = Logger.new(file, shift_age, shift_size)
        @log.level = Logger::ERROR
      else
        @log = Logger.new(STDERR)
        @log.level = Logger::ERROR
      end
      # ポートの設定
      port ||= @config[:port]
      port ||= 9292
      @port = port
      # パスの設定
      base_path ||= @config[:base_path]
      base_path ||= 'julius'
      @juliest ||= @config[:juliest]
      @base_path = base_path
      # サーブレットのステータスの設定
      @status ||= :running
    end

    # Juliest サーブレットへの POST 実行
    def post_juliest(message)
      @status = :relational
      
      host = '127.0.0.1'
      base_path = @juliest[:base_path] # TODO: bugfix
      port = @juliest[:port]
      request_uri = URI.parse('http://'+host+'/'+base_path)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.body= message
      response = Net::HTTP.start(host, port){|http|
        http.request(request)
      }
    
      @status = :running
      return response
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

      # 正しくないパスへのアクセスは弾く
      unless request.path.match(@base_path)
        status = 404
        body<< 'bad request'.to_msgpack
      end
      
      case 
        # GET メソッドの場合、サーブレットのステータスを返す
        when request.get?
          body<< @status.to_msgpack

        # PUT メソッドの場合。かつ、 サイレントモードの場合は
        # PAUSE と RESUME のステータス変更は受け付けない
        when request.put? && @status.eql?(:silent)

          case MessagePack.unpack(request.body)
            when "pause", "resume"
              status = 503
              body<< @status.to_msgpack
            else
              message = MessagePack.unpack(request.body)
              message = message[1..-1].to_s
              @status = message.to_sym
          end

        # PUT メソッドの場合、サーブレットのステータス変更を実行する
        when request.put?
          message = MessagePack.unpack(request.body)
          message = message[1..-1].to_s
          @status = message.to_sym

          body<< true.to_msgpack

        # POST メソッドの場合。かつ、サイレントモードの場合は
        # Juliest サーブレットへの転送を行わない
        when request.post? && @status.eql?(:silent)
          status = 503
          body<< @status.to_msgpack

        # POST メソッドの場合、 Juliest サーブレットへ転送する
        when request.post?
          message = request.body
          post_juliest(request.body)
      end
      
      # レスポンスを返す
      header = Rack::Utils::HeaderHash.new(header)
      res = Rack::Response.new(body, status, header)
      res.finish
    end
  end
end

