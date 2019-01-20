# frozen_string_literal: true

module Types
  class CartDeletePayloadType < Types::BaseObject
    field :deleted_cart_id, ID, null: true, description: "The identifier of the deleted cart"
  end
end
