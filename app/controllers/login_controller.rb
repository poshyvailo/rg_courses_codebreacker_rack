# frozen_string_literal: true

require_relative '../../lib/codebreacker_web/controller'

# /login
class LoginController < Controller
  def index
    if @request.post?
      login = @request.params['login']
      password = @request.params['password']

      user = User.new.load_user(login)
      if user.nil?
        @request.set_flash 'error', 'User not found'
      else
        if user.password_equal? password
          load_unfinished_game(user.login)
          @request.current_user = user
          @request.set_flash 'success', 'You are login'
          return redirect
        else
          @request.set_flash 'error', 'Invalid password'
        end
      end
    end
    render
  end

  private

  def load_unfinished_game(login)
    data = UserGames.load(login)
    @request.game = data[:game] unless data[:game].nil?
    @request.session[:total_attempts] = data[:total_attempts] unless data[:total_attempts].nil?
    @request.session[:total_hints] = data[:total_hints] unless data[:total_hints].nil?
    @request.session[:history] = data[:history] unless data[:history].nil?
    @request.session[:hints] = data[:hints] unless data[:hints].nil?
  end

end