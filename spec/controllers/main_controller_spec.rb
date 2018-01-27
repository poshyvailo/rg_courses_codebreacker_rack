# frozen_string_literal: true

require_relative '../spec_helper'

module CodebreackerWeb
  RSpec.describe MainController do
    include Rack::Test::Methods

    def app
      App.new
    end

    context 'GET request to /' do

      let(:user) do
        user = User.new
        user.login = 'Test'
        user.name = 'Test'
        user.password_hash = '12345'
        user
      end

      it 'return HTTP status code 200' do
        get '/'
        expect(last_response.status).to be == 200
      end

      it 'show "login" button if user not login' do
        get '/'
        expect(last_response.body).to match('login')
      end

      it 'show "register" button if user not login' do
        get '/'
        expect(last_response.body).to match('register')
      end

      it 'show "start new game" button if user login' do
        get '/', {}, 'rack.session' => { user: user }
        expect(last_response.body).to match('start new game')
      end
    end
  end
end
