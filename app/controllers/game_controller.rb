class GameController < Controller
  def index
    render
  end

  def start
    if @request.current_user?
      return redirect 'game' if @request.game?
      return start_game if @request.post?
      return render
    end
    redirect
  end

  private

  def start_game
    player = @request.current_user.name
    game_mode = @request.params['mode']
    @request.game = Game.new(player, game_mode.to_sym)
    binding.pry
    redirect 'game'
  end
end