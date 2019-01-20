# frozen_string_literal: true

module Types
  class ProductRemoveFromCartPayloadType < Types::BaseObject
    field :product, ProductType, null: true, description: "The product that was removed from the cart."
  end
end
