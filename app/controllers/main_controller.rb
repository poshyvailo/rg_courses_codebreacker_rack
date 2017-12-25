class MainController < Controller

  def index
    @test1 = 'Simple text'
    render
  end

  def post
    'main.post'
    render
  end

end