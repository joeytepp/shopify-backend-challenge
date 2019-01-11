# frozen_string_literal: true

module Types
  class ProductDeletePayloadType < Types::BaseObject
    field :deleted_product_id, Integer, null: true, description: "The identifier of the deleted product."
  end
end
