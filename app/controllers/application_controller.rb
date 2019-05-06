require './config/environment'
require 'sinatra/base'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    use Rack::Flash
    set :session_secret, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect '/tweets'
    end
  end

  post '/signup' do

    if params[:username] == '' || params[:email] =='' || params[:password] == ''
      redirect '/signup'
    else
      user = User.create(params)
      session[:user_id] = user.id
      redirect '/tweets'
    end
  end

  helpers do

    def logged_in?
      !!current_user    
    end


    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end
end
