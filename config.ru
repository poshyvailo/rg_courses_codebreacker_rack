require './app'

use Rack::Reloader
use Rack::Static, :urls => %w[/js /css /fonts], :root => 'assets'
use Rack::Session::Cookie, :key => 'rack.session',
    :secret => '123456'

run App.new