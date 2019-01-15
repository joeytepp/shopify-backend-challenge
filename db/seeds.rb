# frozen_string_literal: true

# seed users
user = User.new(first_name: "Tobias", last_name: "Lütke", email: "tobi@shopify.com", password: "password", password_confirmation: "password")
user.save!

# seed stores
store = Store.new(name: "Tobi's Snowboard Store", owner_id: user.id)
store.save!

# seed products
products = Product.create([
    { title: "Snowboard 1", inventory_count: 0, store_id: store.id, price: 201 },
    { title: "Snowboard 2", inventory_count: 10, store_id: store.id, price: 202 },
    { title: "Snowboard 3", inventory_count: 20, store_id: store.id, price: 203 }])

products.each do |product|
  product.save!
end

# seed purchases
purchase = Purchase.new(product_id: products[0].id, user_id: user.id)
purchase.save!
