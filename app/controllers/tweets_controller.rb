class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @users = current_user
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect to "/login"
    end
  end

  get '/tweets/new' do
    if logged_in?
      @user = current_user
      erb :'tweets/create_tweet'
    else
      redirect "/login"
    end
  end

  post '/tweets' do
    @tweet = Tweet.new(content: params[:content], user: current_user)
    @user = current_user
    if logged_in? && !@tweet.content.blank? && @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    else
      flash[:empty_tweet] = "Please enter content for your tweet"
      redirect "/tweets/new"
    end
    tweet = Tweet.create(:content => params["content"], :user_id => user.id)
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to "/login"
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      current_user(session).id = @tweet.user_id
      erb :'tweets/edit_tweet'
    else
      flash[:wrong_user_edit] = "Sorry you can only edit your own tweets"
      redirect to '/tweets'
    end
  end

  patch '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    if params["content"].empty?
      flash[:empty_tweet] = "Please enter content for your tweet"
      redirect to "/tweets/#{params[:id]}/edit"
    end
    tweet.update(:content => params["content"])
    tweet.save
    redirect to "/tweets/#{tweet.id}"
  end

  post '/tweets/:id/delete' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      current_user(session).id = @tweet.user_id
      @tweet.delete
      redirect to '/tweets'
    else
      flash[:wrong_user] = "Sorry you can only delete your own tweets"
      redirect to '/tweets'
    end
  end

end
