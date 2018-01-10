# frozen_string_literal: true

require 'pry'
require 'bundler'
require 'codebreacker'
require 'digest'
require 'yaml'

require_relative 'lib/boot'
require_relative 'lib/codebreacker_web'

require 'dotenv/load'

Bundler.require

use Rack::Reloader
use Rack::Static, urls: %w[/js /css /fonts /images], root: 'assets'
use Rack::Session::Cookie, key: 'rack.session', secret: ENV['SESSION_KEY']

run App.new