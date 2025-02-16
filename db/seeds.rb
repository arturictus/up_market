# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[
   { name: "Acme ltd", share_supply: 100, sold_supply: 0 },
   { name: "Apple inc.", share_supply: 200, sold_supply: 0 },
   { name: "Rockets inc.", share_supply: 300, sold_supply: 0 }
].each do |business_entity|
    BusinessEntity.find_or_create_by!(business_entity)
end
