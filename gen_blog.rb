require 'sinatra/reloader'
require 'sinatra/base'
require 'slim'
require 'erb'
require 'logger'
require "date"

$: << File.join(__dir__, "helper")
require "application_helper"

class GenApp < Sinatra::Base
  register Sinatra::Reloader

  $logger = Logger.new("#{File.dirname(__FILE__)}/log/logger.log")

  get '/' do
    @txt = IO.read("#{__dir__}/md/Arch_install.md")
    @txt.force_encoding("utf-8")
    @md = ApplicationHelper.markdown(@txt)
    @title = "Ruby配列あれこれ"
    @data = Date.today
    slim :index
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
