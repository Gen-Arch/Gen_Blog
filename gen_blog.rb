require 'sinatra/reloader'
require 'sinatra/base'
require 'erb'
require 'logger'
require "date"

$: << File.join(__dir__, "helper")
require "application_helper"

class GenApp < Sinatra::Base
    register Sinatra::Reloader

    $logger = Logger.new("#{File.dirname(__FILE__)}/log/logger.log")
    
    get '/' do
        @md_page = "Arch_install"
        @txt = File.open("#{File.dirname(__FILE__)}/md/#{@md_page}.md", "rb").read
        @txt.force_encoding("utf-8")
        @md = ApplicationHelper.markdown(@txt)
        @title = "Ruby配列あれこれ"
        @data = Date.today
        erb :index
    end
    
    get '/create' do
        erb :create
    end

    get '/highlight.css' do
        #Rouge css
        headers 'Content-Type' => 'text/css'
        Rouge::Themes::Github.render(scope: '.highlight')
    end
end

GenApp.run!
