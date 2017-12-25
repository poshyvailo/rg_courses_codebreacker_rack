require 'pry'
require './lib/router'
require './lib/boot'

class App
  def initialize
    @router = Router.new
  end

  def call(env)
    @router.route(env)
  end
end