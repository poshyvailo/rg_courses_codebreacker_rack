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
    if class_method_exist?
      if template_file_exist?
        @body = send(action)
        response
      else
        message = 'Not found template file'
        error message, 500
      end
    else
      redirect @controller
    end
  end

  def render(template = @action.to_s, layout = Setting::DEFAULT_LAYOUT)
    @template = render_template template
    render_layout layout
  end

  def error(message, code)
    @controller = 'error'
    @status_code = code
    @message = message
    @body = render 'error'
    response
  end

  private

  def class_method_exist?
    self.respond_to? @action
  end

  def template_file_exist?
    File.exist? template_file(@action.to_s)
  end

  def response
    Rack::Response.new([@body], @status_code, @header)
  end

  def render_layout(layout = Setting::DEFAULT_LAYOUT)
    _render layout_file(layout)
  end

  def render_template(template)
    _render template_file(template)
  end

  def layout_file(layout)
    File.join(Setting::VIEWS_PATH, layout + Setting::ERB_EXTENSION)
  end

  def template_file(template)
    File.join(Setting::TEMPLATE_PATH, @controller, template + Setting::ERB_EXTENSION)
  end

  def _render(temp)
    ERB.new(File.read(temp)).result( binding )
  end

  def redirect(to = '')
    Rack::Response.new do |response|
      response.redirect("/#{to}")
    end
  end
end