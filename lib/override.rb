# frozen_string_literal: true

module Rack
  # Override class Rack::Request
  class Request
    def set_flash(type, message)
      session[:flash_message] = [] if flash?
      session[:flash_message] << { type: type, message: message }
    end

    def flash?
      session[:flash_message].nil? || session[:flash_message] == []
    end

    def flash
      flash = session[:flash_message]
      clear_flash
      flash
    end

    def clear_flash
      session[:flash_message] = nil
    end

    def current_user?
      session[:user].nil? ? false : true
    end

    def current_user
      session[:user]
    end

    def current_user=(user)
      session[:user] = user
    end

    def game?
      session[:game].nil? ? false : true
    end

    def game
      session[:game]
    end

    def game=(game)
      session[:game] = game
    end
  end
end

module Codebreacker
  # Override class Codebreacker::Statistic
  class Statistic
    def self.load
      YAML.load_file(Setting::STATISTIC_FILE)
    end

    def self.save(data)
      File.write(Setting::STATISTIC_FILE, data.to_yaml)
    end
  end
end
