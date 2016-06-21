class PetController < ApplicationController
  get '/adopt' do
   erb :"pets/adopt"
  end

  post '/adopt' do
    user = User.find_by_id(session[:id])
    pet = Pet.find(params[:id])
    Pet.adopt(pet,user)
    redirect "/pet/#{pet.id}"
  end

  get '/pets/new' do
    erb :"pets/new"
  end

  post '/pets/new' do
    user = User.find_by_id(session[:id])
    pet = Pet.new(params)
    pet.user_id = user.id
    if pet.save
      redirect "#{user.username}/account"
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

 
end