require 'slim'
require 'sinatra/base'

require_relative "lib/application_helper"

class GenApp < Sinatra::Base
  configure :production do
    set :server, :puma
  end

  configure :development do
    Bundler.setup(:default, :development)
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  configure do
    url = (ENV["ELASTICSEARCH_URL"] || "http://localhost:9200")
    @client = Elasticsearch::Client.new url: url, log: true
    @index  = "gen_blog"
  end

  before do
    request.script_name = "/gen_blog"
  end

  helpers do
    def arg_factory(type, **hash)
      #elastic gem 変数調整用
      default = {index: @index, type: type}
      default.merge(hash) if hash
    end

    def jbuilder(query)
      #elastic gem method => search
      #json変数 調整用
      raise unless query.is_a?(Hash)
      raise unless query.size == 1

      key, val = query.first
      {query: {match: {key.to_sym => {query: val, operator: "and"}}}}
    rescue => err
      raise ArgumentError, "jbuilder Error!!"
    end

    def err_json!(req, err=nil)
      #err status conversion => json
      req.merge({result: err}).to_json
    end
  end

  get '/' do
    data = client.search(arg_factory("blog"))
    md   = ApplicationHelper.markdown(data[:txt])

    slim :index
  end

  get '/create' do
    erb :create
  end

  get '/highlight.css' do
    #Rouge css
    headers 'Content-Type' => 'text/css'
    ApplicationHelper.get_css
  end

  run! if app_file == $0
end

