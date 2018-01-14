# frozen_string_literal: true

# App class
class App
  def initialize
    @router = Router.new
  end

  def call(env)
    @router.route env
  end
end
