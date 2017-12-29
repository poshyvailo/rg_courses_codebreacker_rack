# frozen_string_literal: true

# Router
class Router
  def route(env)
    controller, action = parse_path env['REQUEST_PATH']
    file = "#{controller}_controller.rb"
    controller_path = File.join(Setting::CONTROLLER_PATH, file)
    if File.exist? controller_path
      class_name = "#{controller.capitalize}Controller"
      controller_class = Object.const_get(class_name, Class.new)
      controller_class.new(controller, action.to_sym, env).call
    else
      WebError.new.client_error('Page not found')
    end
  end

  def parse_path(path)
    controller, action = path[1..-1].split('/')
    controller ||= Setting::DEFAULT_CONTROLLER
    action ||= Setting::DEFAULT_ACTION
    [controller, action]
  end
end