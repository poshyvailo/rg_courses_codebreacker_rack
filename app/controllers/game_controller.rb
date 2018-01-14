class GameController < Controller
  def index
    if @request.post?
      return redirect 'game/start' unless @request.game?
      guess_code = @request.params['guess_code']
      return invalid_guess_message unless @request.game.valid_guess? guess_code
      make_guess guess_code
      return game_lose if game_lose?
      return game_win if game_win?
    end
    return redirect 'game/start' unless @request.game?
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

  def hint
    return redirect 'game' unless @request.post?
    return no_hints_message if @request.game.hints.zero?
    make_hint
    redirect 'game'
  end

  private

  def start_game
    # binding.pry
    player = @request.current_user.name
    game_mode = @request.params['mode']
    @request.game = Game.new(player, game_mode.to_sym)
    @request.session[:total_attempts] = @request.game.attempts
    @request.session[:total_hints] = @request.game.hints
    save_game_stat
    redirect 'game'
  end

  def make_guess(guess_code)
    result = @request.game.make_guess guess_code
    add_history guess_code, result
    save_game_stat
  end

  def make_hint
    @request.session[:hints] = [] if @request.session[:hints].nil?
    @request.session[:hints] << @request.game.show_hint
    save_game_stat
  end

  def invalid_guess_message
    @request.set_flash 'error', 'Invalid guess code'
    redirect 'game'
  end

  def no_hints_message
    @request.set_flash 'error', 'No hint'
    redirect 'game'
  end

  def add_history(guess_code, result)
    @request.session[:history] = [] if @request.session[:history].nil?
    @request.session[:history] << [guess_code, result]
  end

  def game_win?
    @request.game.status == :win
  end

  def game_lose?
    @request.game.status == :lose
  end

  def end_game
    save_game_result
    @secret_code = @request.game.secret_code
    @request.session[:history] = nil
    @request.session[:hints] = nil
    @request.session[:total_attempts] = nil
    @request.session[:total_hints] = nil
    @request.game = nil
    save_game_stat
    binding.pry
  end

  def game_win
    end_game
    render 'win'
  end

  def game_lose
    end_game
    render 'lose'
  end

  def save_game_result
    data = {
      name: @request.game.player.to_s.to_sym,
      mode: @request.game.game_mode.to_sym,
      status: @request.game.status.to_sym
    }
    Statistic.insert(data)
  end

  def save_game_stat
    login = @request.current_user.login
    data = {
      game: @request.game,
      total_attempts: @request.session[:total_attempts],
      total_hints: @request.session[:total_hints],
      history: @request.session[:history],
      hints: @request.session[:hints]
    }
    UserGames.save(login, data)
  end
end