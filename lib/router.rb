require 'pry'

class Router
  def route(env)
    controller, action = parse_path env['REQUEST_PATH']
    controller_path = File.join(Setting::CONTROLLER_PATH, "#{controller}_controller.rb")
    if File.exist? controller_path
      controller_class = Object.const_get("#{controller.capitalize}Controller", Class.new)
      controller_class.new(controller: controller, action: action.to_sym).call
    else

    end
  end

  def parse_path(path)
    controller, action = path[1..-1].split('/')
    controller ||= Setting::DEFAULT_CONTROLLER
    action ||= Setting::DEFAULT_ACTION
    [controller, action]
  end
end