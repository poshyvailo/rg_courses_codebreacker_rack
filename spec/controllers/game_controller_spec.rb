# frozen_string_literal: true

require_relative '../spec_helper'

module CodebreackerWeb
  RSpec.describe GameController do
    include Rack::Test::Methods

    def app
      App.new
    end

    context 'GET request to /game' do

      it 'redirect if game not start' do
        get '/game'
        expect(last_response.status).to be == 302
      end

      it 'get status code 200 if game started' do
        game = Game.new('player', :normal)
        get '/game', {}, 'rack.session' => { game: game }
        expect(last_response.status).to be == 200
      end

      it 'show win page if player win' do
        allow_any_instance_of(GameController).to receive(:save_game_stat)
        allow_any_instance_of(GameController).to receive(:valid_code?).and_return(true)
        allow_any_instance_of(GameController).to receive(:make_guess)

        game = Game.new('player', :normal)
        expect(game).to receive(:status).and_return(:win).at_least(:once)

        post '/game', {}, 'rack.session' => { game: game }
        expect(last_response.body).to match('win')
      end

      it 'show lose page if player lose' do
        allow_any_instance_of(GameController).to receive(:save_game_stat)
        allow_any_instance_of(GameController).to receive(:valid_code?).and_return(true)
        allow_any_instance_of(GameController).to receive(:make_guess)

        game = Game.new('player', :normal)
        expect(game).to receive(:status).and_return(:lose).at_least(:once)

        post '/game', {}, 'rack.session' => { game: game }
        expect(last_response.body).to match('lose')
      end
    end
  end
end