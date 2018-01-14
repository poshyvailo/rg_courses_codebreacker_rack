# frozen_string_literal: true

# Logout class
class LogoutController < Controller
  # /logout
  def index
    return redirect if @request.session[:user].nil?
    @request.session[:user] = nil
    @request.set_flash 'success', 'You are logout'
    redirect 'login'
  end
end