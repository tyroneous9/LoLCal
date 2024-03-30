# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

require 'json'

# Define the method before it's called
def parse_json_attribute(attribute)
  attribute.is_a?(String) ? JSON.parse(attribute) : attribute
rescue JSON::ParserError
  attribute # Return original attribute if parsing fails
end

# Path to the JSON file
file_path = Rails.root.join('downloads', 'items.json')

if File.exist?(file_path)
  # Read the file and parse the JSON
  file = File.read(file_path)
  data = JSON.parse(file)
  items_data = data['data'] || {}

  puts "Inserting Data to Table items"

  items_data.each do |id, item|
    Item.create(
      id: id,
      name: item['name'],
      description: item['description'],
      colloq: item['colloq'],
      plaintext: item['plaintext'],
      consumed: item['consumed'] || false,
      stacks: item['stacks'] || 1,
      depth: item['depth'] || 1,
      consume_on_full: item['consumeOnFull'] || false,
      from_array: item['from'] || [],
      into_array: item['into'] || [],
      special_recipe: item['specialRecipe'] || 0,
      in_store: item['inStore'] || true,
      hide_from_all: item['hideFromAll'] || false,
      required_champion: item['requiredChampion'],
      required_ally: item['requiredAlly'],
      stats: parse_json_attribute(item['stats']),
      tags: item['tags'] || [],
      maps: parse_json_attribute(item['maps']),
      gold: parse_json_attribute(item['gold']),
      image: parse_json_attribute(item['image'])
    )
  end
else
  puts "The file #{file_path} does not exist."
end
