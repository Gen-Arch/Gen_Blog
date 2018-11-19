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
    @md = Hash.new
    Dir.glob("#{__dir__}/md/*.md").each do |file|
      @title = File.basename(file)
      @md[@title] = (@md[@title] || {}).merge(:data => Date.today)
      @txt = IO.read(file)
      @txt.force_encoding("utf-8")
      @md[@title] = (@md[@title] || {}).merge(:md => ApplicationHelper.markdown(@txt))
    end
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
