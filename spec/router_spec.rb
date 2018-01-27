# frozen_string_literal: true

require_relative 'spec_helper'

module CodebreackerWeb
  RSpec.describe Router do
    before(:all) { @router = Router.new }
    context '#parse_path' do
      [
        %w[/ main index],
        %w[/main main index],
        %w[/main/action main action],
        %w[/posts/create posts create],
        %w[/posts/create/foo/bar posts create]
      ].each do |line|
        path, controller, action = line
        it "path #{path.inspect} returned controller: #{controller.inspect}, action: #{action.inspect}" do
          expect(@router.parse_path(path)).to include(controller, action)
        end
      end
    end
  end
end