class LogoutController < Controller
  def index
    @request.session[:user] = nil
    @request.set_flash 'success', 'You are logout'
    redirect 'login'
  end
end