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
get '/Search' do
  json animals: SeenAnimal.where('species ILIKE ?', "%#{params["species"]}%")
end

# Add an animal
# e.g.
# {
#   "animals": {
#     "species": "Duck",
#     "count_of_times_seen": 10,
#     "location_of_last_seen": "Pond"
#   }
# }
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

# Add one to count of last seen for specific animal by id
put '/Animal/:id' do
  found_animal = SeenAnimal.find(params["id"])
  new_count = found_animal.count_of_times_seen + 1
  found_animal.update(count_of_times_seen: new_count)
  json animals: found_animal
end

# Delete a specific animal from the table by its location
delete '/Animal/:location' do
  deleted_animal = SeenAnimal.where(location_of_last_seen: params["location"])
  deleted_animal.destroy
  json animals: deleted_animal
end