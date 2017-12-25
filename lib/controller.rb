class Controller

  attr_reader :controller, :action
  attr_accessor :body, :status_code, :header

  def initialize(controller: nil, action: nil)
    @controller = controller
    @action = action
    @status_code = 200
    @header = {}
  end

  def call
    @body = send(action)
    Rack::Response.new([@body], @status_code, @header)
  end

  def render(template = @action, layout = Setting::DEFAULT_LAYOUT)
    @template = render_template template.to_s
    render_layout layout
  end

  private

  def render_layout(layout)
    layout_path = File.join(Setting::VIEWS_PATH, layout + Setting::ERB_EXTENSION)
    _render layout_path
  end

  def render_template(template)
    template_path = File.join(Setting::TEMPLATE_PATH, @controller, template + Setting::ERB_EXTENSION)
    _render template_path
  end

  def _render(temp)
    ERB.new(File.read(temp)).result( binding )
  end

end