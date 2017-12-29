# frozen_string_literal: true

require 'pry'
require 'bundler'
require 'codebreacker'
require './app'
require './lib/router'
require './lib/boot'

require 'dotenv/load'

Bundler.require

use Rack::Reloader
use Rack::Static, urls: %w[/js /css /fonts /images], root: 'assets'
use Rack::Session::Cookie, key: 'rack.session', secret: ENV['SESSION_KEY']

run App.new