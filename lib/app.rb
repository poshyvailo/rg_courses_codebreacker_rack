require 'erb'
require 'codebreacker'

module CodebreakerRack
  class Racker
    def self.call(env)
      new(env).response
    end

    def initialize(env)
      @request = Rack::Request.new(env)
    end

    def response
      case @request.path
        when '/'  then render_template('main')
        when '/start'  then start
        when '/game' then game
        when '/end' then end_game
        when '/win' then render_template 'win'
        when '/lose' then render_template 'lose'
        when '/restart' then restart
        else Rack::Response.new('Not Found', 404)
      end
    end

    def start
      if @request.post?
        name = @request.params['name']
        game_mode = @request.params['mode'].to_sym
        @request.session[:game] = Game.new(name, game_mode)
        @request.session[:total_attempts] = current_game.attempts
        redirect('game')
      else
        render_template('start')
      end
    end

    def game

      return redirect 'end' if current_game.status != :play

      if @request.post?
        guess_code = @request.params['guess_code']
        result = current_game.make_guess guess_code
        if session[:history].nil?
          @request.session[:history] = [[guess_code, result]]
        else
          @request.session[:history] += [[guess_code, result]]
        end
        redirect 'game'
      end
      render_template('game')
    end

    def end_game
      save_game
      clear_session
      redirect current_game.status.to_s
    end

    def save_game
      data = {
          name: current_game.player.to_s.to_sym,
          mode: current_game.game_mode.to_sym,
          ststus: current_game.status.to_sym
      }
      Statistic.insert(data)
    end

    def render(template)
      path = File.expand_path("../views/#{template}", __FILE__)
      ERB.new(File.read(path)).result(binding)
    end

    def render_template (template = nil, layout = 'layout')
      @template = "templates/#{template}.html.erb" unless template.nil?
      Rack::Response.new(render("#{layout}.html.erb"))
    end

    def redirect(where = '')
      Rack::Response.new do |response|
        response.redirect("/#{where}")
      end
    end

    def current_game
      @request.session[:game]
    end

    def total_attempts
      @request.session[:total_attempts]
    end

    def session
      @request.session
    end

    def restart
      clear_session
      redirect 'start'
    end

    def clear_session
      @request.session.clear
    end

  end
end