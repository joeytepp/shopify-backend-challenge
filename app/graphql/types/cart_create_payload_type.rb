# frozen_string_literal: true

module Types
  class CartCreatePayloadType < Types::BaseObject
    field :cart, CartType, null: true, description: "The newly created cart resource."
  end
end
