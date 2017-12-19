require './lib/app'

use Rack::Reloader
use Rack::Static, :urls => %w[/js /css], :root => 'assets'
use Rack::Session::Cookie, :key => 'rack.session',
    :secret => '123456'

run CodebreakerRack::Racker