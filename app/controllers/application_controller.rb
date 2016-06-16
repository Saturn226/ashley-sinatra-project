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

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect '/account'
    else
      raise 'failure'
    end

    redirect '/account'
  end

  post "/signup" do

    @user = User.new(params)
    if @user.save
     #raise @user.inspect
      redirect '/account'
    else
      raise "failure"
    end

  end

  get '/account' do
    @user = User.find_by_id(session[:id])
    erb :"users/account"
  end

  post '/logout' do
    session.clear
    redirect '/'
  end


end
