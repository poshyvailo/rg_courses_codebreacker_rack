# frozen_string_literal: true

# /login
class LoginController < Controller
  def index
    return render unless @request.post?
    login = @request.params['login']
    password = @request.params['password']
    user = User.new.load_user(login)
    return error_message 'Invalid login or password' if user.nil?
    return error_message 'Invalid password' unless user.password_equal? password
    load_unfinished_game(user.login)
    @request.current_user = user
    @request.set_flash 'success', 'You are login'
    redirect
  end

  private

  def load_unfinished_game(login)
    data = UserGames.load login
    return if data.nil?
    @request.game = data[:game]
    %i[total_attempts total_hints history hints].each do |key|
      @request.session[key] = data[key]
    end
  end

  def error_message(message)
    @request.set_flash 'error', message
    render
  end
end