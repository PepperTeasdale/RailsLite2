require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def root_dir
      File.expand_path('./../../../', __FILE__)
    end

    def render(template_name)
      template_path = "./views/#{self.class.to_s.underscore}/#{template_name}.html.erb"

      template = File.read(
        File.expand_path(template_path, root_dir)
        )

      erb_template = ERB.new(template).result(binding)
      render_content(erb_template, 'text/html')
    end
  end
end
