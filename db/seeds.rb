# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

owners = [ { name: "John Doe" }, { name: "Steve Jobs" }, { name: "Albert Einstein" } ].map do |attrs|
    BusinessOwner.find_or_create_by!(attrs)
end

entities = [
   { name: "Acme ltd", share_supply: 100, sold_supply: 0 },
   { name: "Apple inc.", share_supply: 200, sold_supply: 0 },
   { name: "Rockets inc.", share_supply: 300, sold_supply: 0 }
].each_with_index.map do |attrs, i|
    owner = owners[i]
    BusinessEntity.find_or_create_by!(attrs.merge(business_owner: owner))
end

buyer = Buyer.create!(name: "John Doe")

orders = [
    { shares: 10, price_per_share: 10 },
    { shares: 20, price_per_share: 20 },
    { shares: 30, price_per_share: 30 },
    { shares: 40, price_per_share: 40 },
    { shares: 50, price_per_share: 50 },
    { shares: 60, price_per_share: 60 },
    { shares: 70, price_per_share: 70 },
    { shares: 80, price_per_share: 80 },
    { shares: 90, price_per_share: 90 }
].each do |attrs|
    Order.create_order!(buyer: buyer, business_entity: entities.sample, **attrs)
end

(0..3).to_a().each do |i|
    order = orders[i]
    Order.create_and_execute!(buyer: buyer, business_entity: entities.sample, **order)
end
