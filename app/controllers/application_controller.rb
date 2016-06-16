require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    @user = User.new(params[:user])
    if @user.save
      raise "success"
      #redirect '/account'
    else
      raise "failure"
    end
    #erb :"users/account"
    #redirect '/account'
  end

  get '/account' do
    erb :"users/account"
  end

end
