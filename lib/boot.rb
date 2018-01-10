# frozen_string_literal: true

# lib directory
Dir[File.join(File.dirname(__dir__), 'lib', '**', '*.rb')].each do |file|
  require file
end

# app directory
Dir[File.join(File.dirname(__dir__), 'app', '**', '*.rb')].each do |file|
  require file
end

class Setting
  ROOT_PATH = File.dirname(__dir__).freeze
  APP_PATH = File.join(ROOT_PATH, 'app').freeze
  LIB_PATH = File.join(ROOT_PATH, 'lib').freeze
  STORAGE_PATH = File.join(ROOT_PATH, 'storage').freeze

  CONTROLLER_PATH = File.join(APP_PATH, 'controllers').freeze
  VIEWS_PATH = File.join(APP_PATH, 'views').freeze
  TEMPLATE_PATH = File.join(VIEWS_PATH, 'templates').freeze

  DEFAULT_LAYOUT = 'layout'
  ERB_EXTENSION = '.html.erb'

  DEFAULT_CONTROLLER = 'main'
  DEFAULT_ACTION = 'index'

  DEFAULT_ERROR_PATH = File.join(VIEWS_PATH, 'errors').freeze
  DEFAULT_ERROR_TEMPLATE = 'error'
end