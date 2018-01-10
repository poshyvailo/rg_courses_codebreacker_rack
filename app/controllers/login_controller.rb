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
end