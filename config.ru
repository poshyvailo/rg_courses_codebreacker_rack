# frozen_string_literal: true

require_relative 'lib/boot'

Bundler.require

use Rack::Reloader
use Rack::Static,
    urls: %w[/js /css /fonts /images],
    root: 'assets'
use Rack::Session::Cookie,
    key: 'rack.session',
    secret: ENV['SESSION_KEY'],
    coder: Crypto.new

run App.new