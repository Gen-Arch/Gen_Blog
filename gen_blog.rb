require 'sinatra'
require 'sinatra/reloader'
require 'redcarpet'
require 'rouge'
require 'rouge/plugins/redcarpet'

get '/' do
    parser_options = {
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        disable_indented_code_blocks: true,
        underline: true
    }
    class HTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet 
    end

    markdown = Redcarpet::Markdown.new(HTML,  parser_options)
    erb :index
end

get '/highlight.css' do
    headers 'Content-Type' => 'text/css'
    Rouge::Themes::Base16.mode(:light).render(scope: '.highlight')
  end
