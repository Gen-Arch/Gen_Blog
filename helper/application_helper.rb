require "redcarpet"
require "pygments.rb"
require "nokogiri"
require 'logger'


$logger = Logger.new("#{File.dirname(__FILE__)}/helper.log")

module ApplicationHelper
    def markdown(text)
        html = Redcarpet::Markdown.new(
            Redcarpet::Render::HTML.new(hard_wrap: true),
            tables: true,
            autolink: true,
            superscript: true,
            strikethrough: true,
            no_intra_emphasis: true,
            fenced_code_blocks: true,
            space_after_headers: true
        ).render(text)
        $logger.info(html)
        syntax_highlighter(html)
    end
  
    def syntax_highlighter(html)
        doc = Nokogiri::HTML(html)
        doc.search("pre").each do |pre|
            pre.replace(Pygments.highlight(pre.text.rstrip,lexer: pre.children.attribute("class"))) 
        end
        doc_comp = ""
        doc.to_s.each_line do |line|
            doc_comp += line if line !~ /DOCTYPE|html|body/
        end
        $logger.warn(doc_comp)
        doc_comp.to_s
    end
    module_function :markdown, :syntax_highlighter
  end
