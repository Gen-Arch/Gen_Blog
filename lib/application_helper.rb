require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

module ApplicationHelper
  class HtmlWithRouge < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  class << self
    def markdown(text)
      render = HtmlWithRouge.new
      options = {
        tables: true,
        autolink: true,
        superscript: true,
        strikethrough: true,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        space_after_headers: true
      }
      md = Redcarpet::Markdown.new(render, **options)

      md.render(text)
    end

    def get_css
      Rouge::Themes::Github.render(scope: '.highlight')
    end
  end
end
