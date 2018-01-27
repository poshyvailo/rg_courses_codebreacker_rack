# frozen_string_literal: true

require_relative '../spec_helper'

module CodebreackerWeb
  RSpec.describe LoginController do
    include Rack::Test::Methods

    def app
      App.new
    end

    context 'GET request to /login' do
      it 'return http-status 200' do
        get '/login'
        expect(last_response.status).to be == 200
      end
    end

    context 'POST request to /login' do

      let(:user) do
        user = User.new
        user.login = 'Test'
        user.name = 'Test'
        user.password_hash = '12345'
        user
      end

      it 'return http-status 200' do
        post '/login'
        expect(last_response.status).to be == 200
      end

      it 'show error alert if login nil' do
        post '/login'
        expect(last_response.body).to match('Invalid login or password')
      end

      it 'show error alert if invalid password' do
        post '/login', login: 'test_user'
        expect(last_response.body).to match('Invalid password')
      end

      it 'redirect if user login' do
        allow_any_instance_of(User).to receive(:load_user).and_return(user)
        post '/login', login: 'Test', password: '12345'
        expect(last_response.status).to be == 302
      end

      it 'set user to session' do
        allow_any_instance_of(User).to receive(:load_user).and_return(user)
        post '/login', login: 'Test', password: '12345'
        expect(last_request.env['rack.session'][:user]).to be_truthy
      end

    end
  end
end