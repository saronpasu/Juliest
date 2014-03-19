#-*- encoding: utf-8 -*-

class AquesTalk2::Servlet
  autoload :AquesTalk2, 'aquestalk2'
  autoload :YAML, 'yaml'
  autoload :FileUtils, 'fileutils'
  
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
    SOUND_RESOURCE_DIR = 'resource/voice'
    
    attr_accessor :config,
      :aquestalk2,
      :base_path,
      :player,
      :player_args,
      :status,
      :port,
      :log
    
    def initialize
      open(CONFIG_FILE, 'r'){|f|@config = YAML::load(f.read)[:aquestalk2]}
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
      port ||= @config[:port]
      port ||= 9292
      @port = port
      base_path ||= @config[:base_path]
      base_path ||= 'aquestalk2'
      @base_path = base_path
      player ||= @config[:
      @aquestalk2 = AquesTalk2.new
      @status ||= :running
    end
  end

  def synthe(input)
    @status = :synthe

    source = MessagePack.unpack(input)
    uid = source.object_id
    output = SOUND_RESOURCE_DIR+'/output-'+uid+'.wav'
    @aquestalk2.synthe(source, output)

    @status = :running
    return output
  end

  def play_sound(input)
    @status = :play_sound

    commands = ''
    commands += @player + ' '
    commands += @player_args
    commands += input
    `#{commands}`
    FileUtils.remove input if FileTest.exist?(input)

    @status = :runnning
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
        when 'POST', (@status != :silent)
          input = request.body
          voice = synthe(input)
          play_sound(voice)
          body<< true.to_msgpack
      end
      
      # finish
      header = Rack::Utils::HeaderHash.new(header)
      res = Rack::Response.new(body, status, header)
      res.finish
    end
  end
end

