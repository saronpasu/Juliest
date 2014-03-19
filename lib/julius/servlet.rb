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
  
  
  class Base
    include AquesTalk2
    autoload :Logger, 'logger'
    CONFIG_FILE = 'config/config.yaml'
    LOG_DIR = 'log'
    
    attr_accessor :config,
      :base_path,
      :status,
      :port,
      :juliest,
      :log
    
    def initialize
      open(CONFIG_FILE, 'r'){|f|@config = YAML::load(f.read)[:julius]}
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
      port ||= @config[:port]
      port ||= 9292
      @port = port
      base_path ||= @config[:base_path]
      base_path ||= 'aquestalk2'
      @base_path = base_path
      @status ||= :running
    end
  end

  def post_juliest(message)
    @status = :relational
    
    host = '127.0.0.1'
    base_path = @juliest[:base_path]
    port = @juliest[:port]
    request_uri = URI.parse('http://'+host+'/'+base_path)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body= message
    response = Net::HTTP.start(host, port){|http|
      http.post(request)
    }
    
    @status = :running
    return response
  end

  class App < Base
    require 'rack'
    require 'msgpack'
    
    def call(env)
      request = Rack::Request.new(env)
      request_report = request_scan(request)

      status = 200
      header = {}
      body = []
      result = nil
      
      unless request.path.match(@base_path)
        status 404
        body<< 'bad request'.to_msgpack
      end
      
      case request.method
        when 'GET'
          body<< @status.to_msgpack
        when 'PUT'
          @status = MessagePack.unpack(request.body)
        when 'POST'
          message = request.body
          post_juliest(request.body)
      end
      
      # finish
      header = Rack::Utils::HeaderHash.new(header)
      res = Rack::Response.new(body, status, header)
      res.finish
    end
  end
end

