# frozen_string_literal: true

require 'pry'
require 'bundler'
require 'codebreacker'
require 'digest'
require 'yaml'
require 'dotenv/load'

require_relative 'lib/codebreacker_web'
require_relative 'lib/boot'

Bundler.require

use Rack::Reloader
use Rack::Static,
    urls: %w[/js /css /fonts /images],
    root: 'assets'
use Rack::Session::Cookie,
    key: 'rack.session',
    secret: ENV['SESSION_KEY'],
    coder: Secret.new

run App.new