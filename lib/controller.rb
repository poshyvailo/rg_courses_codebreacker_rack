# frozen_string_literal: true

# Controller class
class Controller
  attr_reader :controller, :action
  attr_accessor :body, :status_code, :header

  def initialize(controller = nil, action = nil, env = nil)
    @request = Rack::Request.new(env)
    @controller = controller
    @action = action
    @status_code = 200
    @header = {}
  end

  def call
    if class_method_exist?
      if template_file_exist?
        @body = send(action)
        @body.is_a?(Rack::Response) ? @body : response
      else
        WebError.new.server_error('Template not found')
      end
    else
      redirect @controller
    end
  end

  def render(template = @action.to_s, layout = Setting::DEFAULT_LAYOUT)
    @template = render_template template
    render_layout layout
  end

  private

  def class_method_exist?
    respond_to? @action
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
    file = template + Setting::ERB_EXTENSION
    File.join(Setting::TEMPLATE_PATH, @controller, file)
  end

  def _render(temp)
    ERB.new(File.read(temp)).result(binding)
  end

  def redirect(to = '')
    Rack::Response.new do |response|
      response.redirect("/#{to}")
    end
  end
end