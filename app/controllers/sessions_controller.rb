class SessionsController < ApplicationController

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

   post '/logout' do
    if logged_in?
      session.clear
    end
    redirect '/'
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
end