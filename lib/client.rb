require 'uri'
require 'net/http'
require 'msgpack'


# テスト/デバッグ実行用の MessagePack クライアント
class Client

  attr_accessor :url

  def initialize(url = nil)
    @url ||= url
  end

  # URI生成
  def create_uri(target)
  end

  # リクエスト生成
  def create_request(method, body)
  end

  # GET リクエスト送信
  def get(target, message)
  end

  # POST リクエスト送信
  def post(target, message)
  end

  # PUT リクエスト送信
  def put(target, message)
  end

end

