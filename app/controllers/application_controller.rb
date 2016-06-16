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
    user = User.new(username: params[:username], 
      password: params[:password], first_name: params[:first_name], last_name: params[:last_name],
      city: params[:city], state: params[:state], email: params[:email])
    if user.save
      session[:id] = user.id
       redirect '/account'
    else
      raise "failure"
    end
    #erb :"users/account"
    #redirect '/account'
  end

  get '/account' do
    @user = User.find_by_id(session[:id])
    erb :"users/account"
  end

end
