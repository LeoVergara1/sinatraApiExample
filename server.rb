# server.rb
require 'sinatra'
require 'active_record'
require "sinatra/namespace"

# DB Setup
ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "root",
  :password => "makingdevs",
  :database => "sinatraApi"
)

class User < ActiveRecord::Base
end

ActiveRecord::Migration.create_table :users, if_not_exists: true do |t|
  t.string :name
  t.string :username
end

User.create(name: 'Brandon', username: "brandonVergara")

class App < Sinatra::Application
end
# Endpoints
namespace '/api/v1' do

  before do
    content_type 'application/json'
  end

  helpers do
    def base_url
      @base_url ||= "#{request.env['rack.url_scheme']}://{request.env['HTTP_HOST']}"
    end

    def json_params
      begin
        JSON.parse(request.body.read)
      rescue
        halt 400, { message:'Invalid JSON' }.to_json
      end
    end
  end


  get '/ ' do
    'Welcome to BookList!'
  end

  get '/users' do
    User.all.to_json
  end

  get '/users/1' do
    halt(404, { message:'User1 Not Found'}.to_json)
  end
end