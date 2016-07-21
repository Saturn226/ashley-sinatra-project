class PetController < ApplicationController
  get '/adopt' do
   erb :"pets/adopt"
  end

  post '/adopt' do
    user = current_user
    pet = Pet.find(params[:id])
    Pet.adopt(pet,user)
    redirect "/pet/#{pet.id}"
  end

  get '/pets/new' do
    erb :"pets/new"
  end

  post '/pets/new' do
    
    #pet = Pet.new(params)
    #pet.user_id = user.id
    if current_user.pets.create(params)
      redirect user_path
    else
      redirect "/pets/new"
    end
  end

  get '/pet/:id' do
    @pet = Pet.find(params[:id])
    erb :'/pets/pet'
  end

  post '/pet/:id/delete' do
    @pet = Pet.find(params[:id])
    @pet.delete
    redirect '/adopt'
  end

  get '/pet/:id/edit' do
    @pet = Pet.find(params[:id])
    if @pet.user.id == session[:id]
      erb :'/pets/edit'
    else
      redirect user_path
    end
  end

  post '/pet/:id/edit' do
    @pet = Pet.find(params[:id])
    @pet.name = params[:name]
    @pet.bio = params[:bio]
    @pet.breed = params[:breed]
    @pet.adoptable = params[:adoptable]
    @pet.price = params[:price]
    @pet.save
    redirect user_path(@pet.user)
  end

 
end