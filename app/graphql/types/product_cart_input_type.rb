# frozen_string_literal: true

module Types
  class ProductCartInputType < Types::BaseInputObject
    argument :product_id, Integer, required: true, description: "The identifier of the product."
    argument :cart_id, Integer, required: true, description: "The identifier of the cart"
  end
end
