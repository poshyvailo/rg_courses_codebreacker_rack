# frozen_string_literal: true

require_relative '../spec_helper'

module CodebreackerWeb
  RSpec.describe RegisterController do
    include Rack::Test::Methods

    def app
      App.new
    end

    context 'GET request to /register' do
      it 'return http-status 200' do
        get '/register'
        expect(last_response.status).to be == 200
      end
    end

    context 'POST request to /register' do

      let(:user) do
        user = User.new
        user.login = 'Test'
        user.name = 'Test'
        user.password_hash = '12345'
        user
      end

      it 'return http-status 200' do
        post '/register', login: 'test_user'
        expect(last_response.status).to be == 200
      end

      it 'show error alert if user exist' do
        allow_any_instance_of(User).to receive(:load_user).and_return(user)
        post '/register', login: 'test_user'
        expect(last_response.body).to match('User exists')
      end

      it 'set user to session' do
        allow_any_instance_of(User).to receive(:save).and_return(user)
        post '/register', login: 'test_user_2', password: '12345', password_confirm: '12345'
        expect(last_request.env['rack.session'][:user]).to be_truthy
      end

      it 'redirect after registration' do
        allow_any_instance_of(User).to receive(:save).and_return(user)
        post '/register', login: 'test_user_2', password: '12345', password_confirm: '12345'
        expect(last_response.status).to be == 302
      end

    end
  end
end