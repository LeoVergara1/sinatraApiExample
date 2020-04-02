# server.rb
require 'sinatra'
require 'active_record'

# DB Setup
ActiveRecord::Base.establish_connection(
  :adapter  => "mysql2",
  :host     => "localhost",
  :username => "rot",
  :password => "makingdevs",
  :database => "sinatraApi"
)

# Endpoints
get '/ ' do
  'Welcome to BookList!'
end

get '/hola' do
  "Hello World"
end