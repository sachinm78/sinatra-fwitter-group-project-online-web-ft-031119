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
    @tweet = Tweet.new(params)
    @user = current_user
    if logged_in? && !@tweet.content.blank? && @tweet.save
      redirect to "/tweets/#{@tweet.id}"  
    else
      redirect "/tweets/new"  
    end
  end


  get "/tweets/:id" do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to "/login"
    end
  end


  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id]) 
      erb :'tweets/edit_tweet'
    else
     redirect to "/login"
    end
  end
  
  patch "/tweets/:id" do
     @tweet = Tweet.find(params[:id])
     if logged_in? && !params[:content].blank?
       @tweet.update(content: params[:content])  
       @tweet.save
       redirect to "/tweets/#{@tweet.id}"
     else
       redirect to "/tweets/#{@tweet.id}/edit"
     end
  end


  delete "/tweets/:id/delete" do
    @tweet = Tweet.find_by_id(params[:id])
     if logged_in? && @tweet.user == current_user
      @tweet.delete
      redirect to '/tweets'
    end
  end

end
