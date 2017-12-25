# lib directory
Dir[File.join(File.dirname(__dir__), 'lib', '*.rb')].each do |file|
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

  CONTROLLER_PATH = File.join(APP_PATH, 'controllers').freeze
  VIEWS_PATH = File.join(APP_PATH, 'views').freeze
  TEMPLATE_PATH = File.join(VIEWS_PATH, 'templates').freeze

  DEFAULT_LAYOUT = 'layout'.freeze
  ERB_EXTENSION = '.html.erb'.freeze

  DEFAULT_CONTROLLER = 'main'.freeze
  DEFAULT_ACTION = 'index'.freeze

  DEFAULT_ERROR_TEMPLATE = 'error'.freeze
end