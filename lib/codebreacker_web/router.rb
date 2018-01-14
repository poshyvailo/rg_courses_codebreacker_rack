# frozen_string_literal: true

# Router class
class Router
  def route(env)
    controller, action = parse_path env['REQUEST_PATH']
    if File.exist? controller_file controller
      controller_class(controller).new(env, controller, action.to_sym).call
    else
      Error.new(env).client_error('Page not found')
    end
  end

  def parse_path(path)
    controller, action = path[1..-1].split('/')
    controller ||= Setting::DEFAULT_CONTROLLER
    action ||= Setting::DEFAULT_ACTION
    [controller, action]
  end

  private

  def controller_file(controller_name)
    File.join(Setting::CONTROLLER_PATH, "#{controller_name}_controller.rb")
  end

  def controller_class(controller_name)
    Object.const_get("#{controller_name.capitalize}Controller", Class.new)
  end
end