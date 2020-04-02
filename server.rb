# server.rb
require 'sinatra'
require 'active_record'

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
get '/ ' do
  'Welcome to BookList!'
end

get '/users' do
  User.all.to_json
end