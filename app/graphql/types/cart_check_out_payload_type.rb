# frozen_string_literal: true

module Types
  class CartCheckOutPayloadType < Types::BaseObject
    field :checked_out_cart_id, Integer, null: false, description: "The identifier of the checked out cart."
  end
end
