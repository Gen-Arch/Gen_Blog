require 'sinatra/reloader'
require 'sinatra/base'
require 'glorify'
require 'erb'
require 'logger'
require "./helper/application_helper.rb"
require "date"

class GenApp < Sinatra::Base
    register Sinatra::Glorify
    register Sinatra::Reloader
    include ApplicationHelper

    before do
        @logger = Logger.new("#{File.dirname(__FILE__)}/log/logger.log")
    end
    
    get '/' do
        @md_page = "Arch_install"
        @txt = File.open("#{File.dirname(__FILE__)}/md/#{@md_page}.md", "rb").read
        @md = markdown(@txt)
        @title = "Ruby配列あれこれ"
        @data = Date.today
        erb :index
    end
    
    get '/create' do
        erb :create
    end
end

GenApp.run!
