# frozen_string_literal: true

module Types
  class CartType < Types::BaseObject
    field :id, Integer, null: false, description: "The identifier of the cart."
    field :checked_out, Boolean, null: false, description: "A boolean representing whether or not the cart has been checked out."
    field :products, [ProductType], null: false, description: "The products in the cart.",
      resolve: ->(obj, _, _) { obj.products }
    field :owner, UserType, null: false, description: "The owner of the cart.",
      resolve: ->(obj, _, _) { User.find_by(id: obj.user_id) }
    field :total_amount, Float, null: false, description: "The total value of the products in the cart (in dollars)",
      resolve: ->(obj, _, _) {
        total = 0
        obj.products.each do |product|
          total += product.price
        end
        total
      }
  end
end
