$LOAD_PATH << 'lib'
require 'rack'
require 'julius'
require 'julius/servlet'

map "/julius" do
  use Rack::Static, :root => "resource"
  run Julius::Servlet::App.new
end


require 'net/http'
require 'uri'
require 'msgpack'

require 'julius'

# load config

def post_julius(message)
  julius = nil
  open(CONFIG_FILE, 'r'){|f|julius = YAML::load(f.read)[:julius]}

  host = '127.0.0.1'
  base_path = julius[:base_path]
  port = julius[:port]
  request_uri = URI.parse('http://'+host+'/'+base_path)
  request = Net::HTTP::Post.new(uri.request_uri)
  request.body= message
  response = Net::HTTP.start(host, port){|http|
    http.post(request)
  }
end

def put_julius(status)
  julius = nil
  open(CONFIG_FILE, 'r'){|f|julius = YAML::load(f.read)[:julius]}

  host = '127.0.0.1'
  base_path = julius[:base_path]
  port = julius[:port]
  request_uri = URI.parse('http://'+host+'/'+base_path)
  request = Net::HTTP::Put.new(uri.request_uri)
  request.body= status
  response = Net::HTTP.start(host, port){|http|
    http.put(request)
  }
end

julius = Julius.new
julius.each_message do |message, prompt|
  if prompt.pause then
    status = :pause.to_msgpack
    put_julius(status)
  end
  case message.name
  when :RECOGOUT
    post_julius(message.to_msgpack)
    # puts message.inspect
    # puts message.sentence
  end
  if prompt.resume then
    status = :resume.to_msgpack
    put_julius(status)
  end
end

