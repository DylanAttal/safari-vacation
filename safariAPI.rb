require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'active_record'
require 'rack/cors'

# Allow anyone to access our API via a browser
use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '*'
  end
end

ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "safari_vacation"
)

class SeenAnimal < ActiveRecord::Base
end

# Get all the animals
get '/Animals' do
  json animals: SeenAnimal.all.order(:id)
end

# Search for animal by species
# Doesn't seem to work for me because the URL
# throws everything into lowercase and my database
# has animals with a capital first letter
get '/Search' do
  json animals: SeenAnimal.where(species: params["species"])
end

# Add an animal
post '/Animal' do
  data = JSON.parse(request.body.read)
  animal_params = data["animals"]

  new_animal = SeenAnimal.create(animal_params)

  json animals: new_animal
end

# Get animals from specific location
get '/Animal/:location' do
  json animals: SeenAnimal.where(location_of_last_seen: params["location"])
end

# Add one to count of last seen for specific animal
# It doesn't increment automatically, you have to 
# add one to the count_of_last_seen manually in the body
# of the request as this is set up
put '/Animal/:animal' do
  data = JSON.parse(request.body.read)
  animal_params = data["animals"]
  animal = SeenAnimal.where(species: params["animal"])
  animal.update(animal_params)
  json animals: animal
end

# Delete a specific animal from the table by its id
delete '/Animal/:id' do
  deleted_animal = SeenAnimal.find(params["id"])
  deleted_animal.destroy
  json animals: deleted_animal
end