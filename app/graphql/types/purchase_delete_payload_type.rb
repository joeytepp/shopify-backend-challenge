module Types
  class PurchaseDeletePayloadType < Types::BaseObject
    field :deleted_purchase_id, Integer, null: true, description: "The identifier of the deleted purchase."
  end
end
