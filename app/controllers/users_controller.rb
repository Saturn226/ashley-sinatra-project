class UsersController < ApplicationController

    get "/signup" do
      erb :signup
    end


     get '/:username' do
      if logged_in?
        @user = current_user
        erb :"users/account"
      else
        redirect '/'
      end
    end

    # get "/account" do
    #   if logged_in?
    #     user = User.find_by_id(session[:id])
    #     redirect user_path
    #   else
    #     redirect "/"
    #   end
    # end

    get "/:username/edit" do
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

end