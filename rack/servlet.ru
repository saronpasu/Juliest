$LOAD_PATH << 'lib'
require 'rack'
require 'aquestalk2'
require 'aquestalk2/servlet'

map "/aquestalk2" do
  use Rack::Static, :root => "resource"
  run AquesTalk2::Servlet::App.new
end

require 'julius'
require 'julius/servlet'

map "/julius" do
  use Rack::Static, :root => "resource"
  run Julius::Servlet::App.new
end

__END__
require 'juliest'
require 'juliest/servlet'

map "/juliest" do
  use Rack::Static, :root => "resource"
  run Juliest::Servlet::App.new
end

