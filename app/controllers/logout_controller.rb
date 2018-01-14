class LogoutController < Controller
  def index
    return redirect if @request.session[:user].nil? ||
    @request.session[:user] = nil
    @request.set_flash 'success', 'You are logout'
    redirect 'login'
  end
end