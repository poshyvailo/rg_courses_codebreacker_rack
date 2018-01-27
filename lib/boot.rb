# frozen_string_literal: true

require 'pry'
require 'bundler'
require 'codebreacker'
require 'digest'
require 'yaml'
require 'openssl'
require 'base64'
require 'dotenv/load'

require_relative 'codebreacker_web'
require_relative 'override'

Bundler.require

# lib directory
Dir[File.join(File.dirname(__dir__), 'lib', '**', '*.rb')].each do |file|
  require file
end

# app directory
Dir[File.join(File.dirname(__dir__), 'app', '**', '*.rb')].each do |file|
  require file
end
