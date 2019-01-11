# frozen_string_literal: true

module Types
  class ProductUpdatePayloadType < Types::BaseObject
    field :product, ProductType, null: true, description: "The updated product."
  end
end
