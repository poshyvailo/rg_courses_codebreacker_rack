# frozen_string_literal: true

require_relative '../spec_helper'

module CodebreackerWeb
  RSpec.describe LogoutController do
    include Rack::Test::Methods

    def app
      App.new
    end

    context 'GET request to /logout' do

      let(:user) do
        user = User.new
        user.login = 'Test'
        user.name = 'Test'
        user.password_hash = '12345'
        user
      end

      it 'redirect if user not login' do
        get '/logout'
        expect(last_response.status).to be == 302
      end

      it 'delete user from session' do
        get '/logout', {}, 'rack.session' => { user: user }
        expect(last_request.env['rack.session'][:user]).to be_nil
      end

      it 'redirect after logout' do
        get '/logout', {}, 'rack.session' => { user: user }
        expect(last_response.status).to be == 302
      end

    end
  end
end