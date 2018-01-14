# frozen_string_literal: true

# Register controller
class RegisterController < Controller
  # /register
  def index
    return render unless @request.post?
    login = @request.params['login']
    password = @request.params['password']
    password_confirm = @request.params['password_confirm']

    return error_message 'User exists' if user_exists? login
    unless password_equals? password, password_confirm
      return error_message 'Invalid password'
    end

    @request.current_user = create_user(login, password)
    @request.set_flash 'success', 'User registered'
    redirect
  end

  private

  def create_user(login, password)
    user = User.new
    user.login = login.downcase
    user.name = login
    user.password_hash = password
    user.save
  end

  def password_equals?(password, password_confirm)
    password == password_confirm
  end

  def user_exists?(login)
    User.new.load_user(login)
  end

  def error_message(message)
    @request.set_flash 'error', message
    render
  end
end