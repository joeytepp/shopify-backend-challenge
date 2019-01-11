# frozen_string_literal: true

module Types
  class StoreCreatePayloadType < Types::BaseObject
    field :store, StoreType, null: true, description: "The created store."
  end
end
