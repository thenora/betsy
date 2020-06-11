# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

# MERCHANTS

MERCHANTS_FILE = Rails.root.join('db', 'merchant-seeds.csv')
puts "Loading raw merchant data from #{MERCHANTS_FILE}"

merchant_failures = []
CSV.foreach(MERCHANTS_FILE, :headers => true) do |row|
  merchant = Merchant.new 
  merchant.username = row['username']
  merchant.email = row['email']
  merchant.uid = rand(1..100)
  merchant.provider = "github"
  
  successful = merchant.save

  if !successful
    merchant_failures << merchant
    puts "Failed to save merchant: #{merchant.inspect}"
  else
    puts "created merchant: #{merchant.inspect}"
  end
end

puts "Added #{Merchant.count} merchants"
puts "#{merchant_failures_failures.length} merchants failed to save"

# PRODUCTS

PRODUCTS_FILE = Rails.root.join('db', 'product-seeds.csv')
puts "Loading raw product data from #{PRODUCTS_FILE}"

product_failures = []
CSV.foreach(PRODUCTS_FILE, :headers => true) do |row|
  product = Product.new 
  product.name = row['name']
  product.price = row['price']
  product.inventory = row['creator']
  product.description = row['description']
  product.status = row['status']
  product.photo_url = row['photo_url']
  product.user_id = Merchant.find(rand(1..6)).id
  successful = product.save

  if !successful
    product_failures << product
    puts "Failed to save product: #{product.inspect}"
  else
    puts "created product: #{product.inspect}"
  end
end

puts "Added #{Product.count} products"
puts "#{product_failures.length} products failed to save"

puts "Manually resetting each table's PK sequence"
ActiveRecord::Base.connection.tables.each do |t|
  ActiveRecord::Base.connection.reset_pk_sequence!(t)
end

puts "Done!"