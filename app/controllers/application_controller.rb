require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
    use Rack::Flash
  end

  get "/" do
    if logged_in?
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
      flash[:message] = "Wrong Username or Password"
      redirect "/"
    end
  end

  post "/signup" do
    if params[:user].values.any?{|attribute| attribute == ""}
      flash[:message] = "Must fill out all fields"
      redirect "/signup"
    
    elsif User.all.detect(username: params[:user][:username])
      flash[:message] = "Username already taken"
      redirect "/signup"
    else
      user = User.new(params[:user])
      user.save
      session[:id] = user.id
      redirect user_path
    end

  end

  get '/:username/account' do
    if logged_in?
      @user = current_user
      erb :"users/account"
    else
      redirect '/'
    end
  end

  post '/logout' do
    if logged_in?
      session.clear
    end
    redirect '/'
  end

  get "/account" do
    if logged_in?
      user = User.find_by_id(session[:id])
      redirect user_path
    else
      redirect "/"
    end
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
    elsif params[:user].values.any?{|value| value == ""}
      flash[:message] = "Must fill out all fields"
      redirect '/edit'
    else
      @user = current_user
      @user.first_name = params[:user][:first_name]
      @user.last_name = params[:user][:last_name]
      @user.email = params[:user][:email]
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
      User.find_by(id: session[:id])
    end

    def user_path(user=current_user)
      "/#{user.username}/account"
    end
  end


end
