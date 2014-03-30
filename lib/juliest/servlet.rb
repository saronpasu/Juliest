#-*- encoding: utf-8 -*-
require 'net/http'
require 'uri'

class Juliest::Servlet
  autoload :YAML, 'yaml'
  autoload :Juliest, 'juliest'
  
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
      :aquestalk2,
      :julius,
      :juliest,
      :log
    
    def initialize
      # 設定ファイルの読み込み
      open(CONFIG_FILE, 'r'){|f|@config = YAML::load(f.read)[:juliest]}
      # ログの初期化
      if FileTest.exist?(LOG_DIR) then
        file = LOG_DIR+'/juliest_servlet.log'
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
      base_path ||= 'juliest'
      @aquestalk2 ||= @config[:aquestalk2]
      @julius ||= @config[:julius]
      @juliest ||= Juliest.new(@config[:juliest])
      @base_path = base_path
      # サーブレットのステータスの設定
      @status ||= :running
    end
  end

  # AquesTalk2 サーブレットへの POST 実行
  def post_aquestalk2(message)
    @status = :relational
    
    host = '127.0.0.1'
    base_path = @aquestalk2[:base_path]
    port = @aquestalk2[:port]
    request_uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body= message
    response = Net::HTTP.start(host, port){|http|
      http.post(request)
    }
    
    @status = :running
    return response
  end

  # AquesTalk2 サーブレットへの GET 実行
  def get_aquestalk2
    @status = :relational
    
    host = '127.0.0.1'
    base_path = @aquestalk2[:base_path]
    port = @aquestalk2[:port]
    request_uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(host, port){|http|
      http.get(request)
    }
    
    @status = :running
    return response
  end

  # Julius サーブレットへの PUT 実行
  def put_julius(message)
    @status = :relational
    
    host = '127.0.0.1'
    base_path = @julius[:base_path]
    port = @julius[:port]
    request_uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Put.new(uri.request_uri)
    request.body= message
    response = Net::HTTP.start(host, port){|http|
      http.put(request)
    }
    
    @status = :running
    return response
  end

  # Julius サーブレットへの GET 実行
  def get_julius
    @status = :relational
    
    host = '127.0.0.1'
    base_path = @julius[:base_path]
    port = @julius[:port]
    request_uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = Net::HTTP.start(host, port){|http|
      http.get(request)
    }
    
    @status = :running
    return response
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

        # PUT メソッドの場合、サーブレットのステータス変更を実行する
        when request.put?
          message = MessagePack.unpack(request.body)
          message = message[1..-1].to_s
          @status = message.to_sym
          @juliest.status_change(@status)
          body<< true.to_msgpack

        # POST メソッドの場合、 Juliest 内部処理を行うへ転送する
        when request.post?
          message = request.body
          @juliest.main(message)
      end
      
      # レスポンスを返す
      header = Rack::Utils::HeaderHash.new(header)
      res = Rack::Response.new(body, status, header)
      res.finish
    end
  end
end

