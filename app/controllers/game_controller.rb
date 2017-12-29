class GameController < Controller
  def index
    render
    WebError.new.server_error('Error page....')
  end
end