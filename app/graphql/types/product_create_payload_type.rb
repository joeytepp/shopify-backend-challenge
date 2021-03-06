# frozen_string_literal: true

module Types
  class ProductCreatePayloadType < BaseObject
    field :product, ProductType, null: true, description: "The product created product."
  end
end
