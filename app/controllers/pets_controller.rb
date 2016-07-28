class PetsController < ApplicationController


  get '/pets/adopt' do
   erb :"pets/adopt"
  end

  post '/pets/adopt' do
    if !logged_in?
      redirect '/'
    else
      user = current_user
      pet = Pet.find(params[:id])
      Pet.adopt(pet,user)
      redirect "/pets/#{pet.id}"
    end
  end

  get '/pets/new' do
    erb :"pets/new"
  end


  post '/pets/new' do
    if !logged_in? 
      redirect '/'
    else
      if params.values.any?{|value| value == ""}
        flash[:message] = "Must fill out all fields"
        redirect back
      end

      pet = current_user.pets.build(params)
      if pet.save
        redirect user_path
      else
        redirect "/pets/new"
      end
    end  
  end

  get '/pets/:id' do
    if logged_in?
      @pet = Pet.find(params[:id])
      erb :'/pets/pet'
    else
      redirect "/"
    end
  end

  post '/pets/:id/delete' do
    if logged_in? 
      @pet = Pet.find(params[:id])
      if @pet.user.id == current_user.id
        @pet.delete
        redirect back
      end
    else
      redirect '/'
    end
  end

  get '/pets/:id/edit' do
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

  post '/pets/:id/edit' do
    if logged_in?
      if params.values.any?{|value| value == ""}
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