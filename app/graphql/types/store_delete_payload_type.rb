module Types
  class StoreDeletePayloadType < Types::BaseObject
    field :deletedStoreId, Integer, null: true, description: "The identifier of the store that was deleted."
  end
end