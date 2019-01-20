# frozen_string_literal: true

module Types
  class ProductAddToCartPayloadType < Types::BaseObject
    field :product, ProductType, null: true, description: "The product that was added to the cart."
  end
end
