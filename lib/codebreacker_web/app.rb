# frozen_string_literal: true

# App class
class App

  attr_accessor :user

  def initialize
    @router = Router.new
  end

  def call(env)
    @router.route env
  end
end
