$LOAD_PATH << 'lib'
require 'rack'
require 'aquestalk2'
require 'aquestalk2/servlet'

map "/aquestalk2" do
  use Rack::Static, :root => "resource"
  run AquesTalk2::Servlet::App.new
end

