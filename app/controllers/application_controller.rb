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
      redirect "/#{user.username}/account"
    else
      raise 'failure'
    end

    redirect "/#{user.username}/account"
  end

  post "/signup" do

    user = User.new(params[:user])
    if user.save
     #raise @user.inspect
      redirect "/#{user.username}/account"
    else
      raise "failure"
    end

  end

  get '/:username/account' do
    if logged_in?
      @user = User.find_by_id(session[:id])
      erb :"users/account"
    else
      redirect '/'
    end
  end

  post '/logout' do
    session.clear
    redirect '/'
  end

  get "/account" do
    user = User.find_by_id(session[:id])
    redirect "/#{user.username}/account"
  end

  helpers do
      def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end


end
