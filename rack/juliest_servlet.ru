$LOAD_PATH << 'lib'
require 'rack'
require 'juliest'
require 'juliest/servlet'

map "/juliest" do
  use Rack::Static, :root => "resource"
  run Juliest::Servlet::App.new
end

