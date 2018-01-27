# frozen_string_literal: true

require 'rack'
require 'pry'
require 'bundler'
require 'digest'
require 'yaml'
require 'openssl'
require 'base64'
require 'dotenv/load'

require_relative '../lib/codebreacker_web'
require_relative '../lib/override'

Bundler.require

# lib directory
Dir[File.join(File.dirname(__dir__), 'lib', '**', '*.rb')].each do |file|
  require file
end

# app directory
Dir[File.join(File.dirname(__dir__), 'app', '**', '*.rb')].each do |file|
  require file
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

end
