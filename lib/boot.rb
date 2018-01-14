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

  USER_GAMES_FILE = File.join(STORAGE_PATH, 'user_games.yml').freeze

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

class Secret
  def encode(str)
    cipher = OpenSSL::Cipher::AES256.new(:CBC)
    cipher.encrypt
    cipher.key = ENV['SECRET_KEY']
    cipher.iv = ENV['SECRET_IV']
    str = Marshal.dump str
    str = cipher.update(str) + cipher.final
    Base64.encode64 str
  end

  def decode(str)
    return unless str
    decipher = OpenSSL::Cipher::AES256.new(:CBC)
    decipher.decrypt
    decipher.key = ENV['SECRET_KEY']
    decipher.iv = ENV['SECRET_IV']
    str = Base64.decode64 str
    str = decipher.update(str) + decipher.final
    Marshal.load(str)
  end
end

class Statistic
  def self.load
    YAML.load_file(File.join(Setting::STORAGE_PATH, 'statistic.yml').freeze)
  end

  def self.save(data)
    File.write(File.join(Setting::STORAGE_PATH, 'statistic.yml').freeze, data.to_yaml)
  end
end
