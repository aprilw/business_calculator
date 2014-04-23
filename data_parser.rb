require 'bundler/setup'
require 'sinatra'
require 'csv'
require 'json'
require 'money'

require_relative 'lib/money'
require_relative 'calculator'

get '/' do
  redirect '/calculate'
end

get '/calculate' do
  erb :calculate
end

post '/calculate' do
  content_type :json
  Calculator.new.process_csv(params[:file][:tempfile])
end

