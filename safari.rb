require 'pg'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  adapter: "postgresql",
  database: "safari_vacation"
)

class SeenAnimal < ActiveRecord::Base
end

def	json_print data
  puts JSON.pretty_generate(data.as_json)
end

SeenAnimal.create(species: "Rattlesnake", count_of_times_seen: 5, location_of_last_seen: "Desert")
SeenAnimal.create(species: "Bobcat", count_of_times_seen: 11, location_of_last_seen: "Desert")

puts "Hey, there! We just went on a safari! Wow! How exciting!\nDo you want to see all the animals that we saw?"
answer = gets.chomp
json_print SeenAnimal.all
puts "Uh-oh! We made a mistake when recording information for the zebras!\nTell us how many times we actually saw
the zebras, and where we last saw them!"
puts "How many times did we see the zebras?"
query_number = gets.chomp.to_i
puts "Where did we see the zebras?"
query_text = gets.chomp
SeenAnimal.find(10).update(count_of_times_seen: "#{query_number}", location_of_last_seen: "#{query_text}")
puts "Here's the updated information for the zebras! Thanks!"
json_print SeenAnimal.find(10)
puts "Do you want to see which animals we saw in the jungle?"
answer = gets.chomp
json_print SeenAnimal.where("location_of_last_seen = ?", "Jungle")
puts "The animals we saw in the desert were scary! Let's delete them from our list, okay?"
answer = gets.chomp
puts "Here's our new list!"
json_print SeenAnimal.all
puts "Let's count up the total number of animals that we saw, okay?"
answer = gets.chomp
json_print SeenAnimal.sum("count_of_times_seen")
puts "Let's see how many lions, tigers, and bears we saw, okay?"
answer = gets.chomp
json_print SeenAnimal.where(species: "Lion").or(SeenAnimal.where(species: "Tiger")
.or(SeenAnimal.where(species: "Bear"))).sum("count_of_times_seen")
puts "What an exciting trip! Thanks for going on this safari with us!"
exit