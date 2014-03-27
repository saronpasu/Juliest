require 'uri'
require 'net/http'
require 'msgpack'


# テスト/デバッグ実行用の MessagePack クライアント
class Client

  attr_accessor(
    :url,
    :port
  )

  def initialize(url = nil, port = nil)
    @url ||= url
    @port ||= port
  end

  # URI生成
  def create_uri(target)
    URI.parse(target)
  end

  # リクエスト生成
  def create_request(url = nil, method = nil)
    url ||= @url
    uri = create_uri(url)
    request = nil
    case method
      when "GET"
        request = Net::HTTP::GET.new(uri.request_uri)
      when "PUT"
        request = Net::HTTP::PUT.new(uri.request_uri)
      when "POST"
        request = Net::HTTP::POST.new(uri.request_uri)
      else
        request = Net::HTTP::GET.new(uri.request_uri)
    end
    return request
  end

  # GET リクエスト送信
  def get(target, port = nil, message = nil)
    uri = create_uri(target)
    request = create_request(uri, "GET")
    port ||= @port
    request.body = message.to_msgpack if message
    response = nil
    response = Net::HTTP.start(uri.host, port){|http|
      http.get(request)
    }
    return response
  end

  # POST リクエスト送信
  def post(target, message)
    uri = create_uri(target)
    request = create_request(uri, "POST")
    port ||= @port
    request.body = message.to_msgpack if message
    response = nil
    response = Net::HTTP.start(uri.host, port){|http|
      http.post(request)
    }
    return response
  end

  # PUT リクエスト送信
  def put(target, message)
    uri = create_uri(target)
    request = create_request(uri, "PUT")
    port ||= @port
    request.body = message.to_msgpack if message
    response = nil
    response = Net::HTTP.start(uri.host, port){|http|
      http.put(request)
    }
    return response
  end

end

