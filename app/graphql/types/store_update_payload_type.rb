# frozen_string_literal: true

module Types
  class StoreUpdatePayloadType < Types::BaseObject
    field :store, StoreType, null: true, description: "The updated store."
  end
end
