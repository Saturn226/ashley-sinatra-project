require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    if session[:id]
      redirect "/account"
    else
      erb :index
    end
  end

  get "/signup" do
    erb :signup
  end

  post "/login" do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect user_path
    else
      redirect "/"
    end

    #redirect "/#{user.username}/account"
  end

  post "/signup" do

    user = User.new(params[:user])
    if user.save
     #raise @user.inspect
      redirect user_path
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
    redirect user_path
  end

  get "/edit" do
    if logged_in?
      erb :"users/edit"
    else
      redirect '/'
    end
  end

  post "/edit" do
    if !logged_in?
      redirect '/'
    else
      @user = current_user
      @user.first_name = params[:user][:first_name]
      @user.last_name = params[:user][:last_name]
      @user.email = params[:email]
      @user.state = params[:user][:state]
      @user.city = params[:user][:city]
      
      if@user.save
        redirect user_path
      else
        redirect '/edit'
      end
    end
       
  end

  helpers do
      def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end

    def user_path
      "/#{current_user.username}/account"
    end
  end


end
