# frozen_string_literal: true

# Controller class
class Controller
  attr_reader :controller, :action, :request
  attr_accessor :body, :status_code, :header

  def initialize(env, controller = nil, action = nil)
    @env = env
    @request = Rack::Request.new(env)
    @controller = controller
    @action = action
    @status_code = 200
    @header = {}
  end

  def call
    return redirect @controller unless class_method_exist?
    @body = public_send(action)
    @body.is_a?(Rack::Response) ? @body : response
  end

  def render(template = @action.to_s, layout = Setting::DEFAULT_LAYOUT)
    if template_file_exist? template
      @template = render_template template
      render_layout layout
    else
      Error.new(@env).server_error('Template not found')
    end
  end

  private

  def response
    Rack::Response.new([@body], @status_code, @header).finish
  end

  def redirect(to = '')
    Rack::Response.new do |response|
      response.redirect("/#{to}")
    end
  end

  def class_method_exist?
    respond_to? @action
  end

  def layout_file(layout)
    File.join(Setting::VIEWS_PATH, layout + Setting::ERB_EXTENSION)
  end

  def template_file(template)
    file = template + Setting::ERB_EXTENSION
    File.join(Setting::TEMPLATE_PATH, @controller, file)
  end

  def template_file_exist?(template)
    File.exist? template_file template
  end

  def render_layout(layout = Setting::DEFAULT_LAYOUT)
    _render layout_file(layout)
  end

  def render_template(template)
    _render template_file(template)
  end

  def _render(temp)
    ERB.new(File.read(temp)).result(binding)
  end
end