# frozen_string_literal: true

require 'pry'
require 'bundler'
require 'codebreacker'
require 'digest'
require 'yaml'
require 'dotenv/load'

require_relative 'codebreacker_web'

# lib directory
Dir[File.join(File.dirname(__dir__), 'lib', '**', '*.rb')].each do |file|
  require file
end

# app directory
Dir[File.join(File.dirname(__dir__), 'app', '**', '*.rb')].each do |file|
  require file
end
