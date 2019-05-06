class UsersController < ApplicationController
  
  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect to '/tweets'
    end
  end

  post '/signup' do
    params.each do |label, input|
      if input.empty?
        flash[:new_user_error] = "Please enter a value for #{label}"
        redirect to '/signup'
      end
    end
    @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
    @user.save
    session[:user_id] = @user.id
    redirect to '/tweets'
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/tweets'  
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect to '/tweets'
    else
      flash[:login_error] = "Incorrect login. Please try again."
      redirect to '/signup'
    end
  end
  
  get '/logout' do
     if !logged_in?
      redirect '/'
    else
      session.clear
      redirect to "/login"
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

end
