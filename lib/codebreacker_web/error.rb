# frozen_string_literal: true

require_relative 'controller'

# Error class
class Error < Controller
  def client_error(message = nil, status_code = 404, header = {})
    render_error message, status_code, header
  end

  def server_error(message = nil, status_code = 500)
    render_error message, status_code, header
  end

  private

  def render_error(message = nil, status_code = 500, header = {})
    message ||= 'Page not found'
    # binding.pry
    @status_code = status_code
    @header = header
    @message = message
    @body = render Setting::DEFAULT_ERROR_TEMPLATE
    response
  end

  def template_file(template)
    File.join(Setting::DEFAULT_ERROR_PATH, template + Setting::ERB_EXTENSION)
  end
end