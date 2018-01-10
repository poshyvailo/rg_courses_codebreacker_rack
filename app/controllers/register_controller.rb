require_relative '../../lib/codebreacker_web/controller'

class RegisterController < Controller
  def index
    if @request.post?
      login = @request.params['login']
      password = @request.params['password']
      password_confirm = @request.params['password_confirm']

      unless password_equals? password, password_confirm
        @request.set_flash'error', 'Invalid password'
      end

      if user_exists? login
        @request.set_flash'error', 'User exists'
      end

      if @request.flash_empty?
        @request.current_user = create_user(login, password)
        @request.set_flash 'success', 'User registered'
        return redirect
      end
    end
    render
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

end