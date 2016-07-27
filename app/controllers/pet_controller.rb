class PetController < ApplicationController
  # before do
  #   if !logged_in?
  #     redirect '/' unless request.path_info == '/'
  #   end
  # end


  get '/adopt' do
   erb :"pets/adopt"
  end

  post '/adopt' do
    if !logged_in?
      redirect '/'
    else
      user = current_user
      pet = Pet.find(params[:id])
      Pet.adopt(pet,user)
      redirect "/pet/#{pet.id}"
    end
  end

  get '/pets/new' do
    erb :"pets/new"
  end


  post '/pets/new' do
    if !logged_in? 
      redirect '/'
    else
      pet = current_user.pets.build(params)
      if pet.save
        redirect user_path
      else
        redirect "/pets/new"
      end
    end  
  end

  get '/pet/:id' do
    if logged_in?
      @pet = Pet.find(params[:id])
      erb :'/pets/pet'
    else
      redirect "/"
    end
  end

  post '/pet/:id/delete' do
    if logged_in? 
      @pet = Pet.find(params[:id])
      if @pet.user.id == current_user.id
        @pet.delete
        redirect '/adopt'
      end
    else
      redirect '/'
    end
  end

  get '/pet/:id/edit' do
    if logged_in? 
      @pet = Pet.find(params[:id])
      if @pet.user.id == current_user.id
        erb :'/pets/edit'
      else
        redirect user_path
      end
    else
      redirect '/'
    end
  end

  post '/pet/:id/edit' do
    if logged_in?
      if params.values.any?{|value| value != ""}
        flash[:message] = "Must fill out all fields"
        redirect back
      else
        @pet = Pet.find(params[:id])
        @pet.name = params[:name]
        @pet.bio = params[:bio]
        @pet.breed = params[:breed]
        @pet.adoptable = params[:adoptable]
        @pet.price = params[:price]
        @pet.save
        redirect user_path(@pet.user)
      end
    else
      redirect '/'
    end
  end


 
end