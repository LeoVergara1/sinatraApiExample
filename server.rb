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
  #validates :name, presence: true
end
class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_json(*)
    data = {
      id:@user.id.to_s,
      name:@user.name,
      username:@user.username
    }
    data[:errors] = @user.errors if@user.errors.any?
    data
  end
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
    'Welcome to userList!'
  end

  get '/users' do
    User.all.to_json
  end

  post '/users' do
    user = User.new(json_params)
    if user.save
      status 201
    else
      status 422
      body UserSerializer.new(user).to_json
    end
  end

  delete '/users/:id' do |id|
    user = User.where(id: id).first
    user.destroy if user
    status 204
  end

  get '/users/:id' do |id|
    user = User.where(id: id).first
    if user
      user.to_json
    else
      halt(404, { message:'User Not Found'}.to_json)
    end
  end
end