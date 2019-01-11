module Types
  class PurchaseCreatePayloadType < Types::BaseObject
    field :purchase, PurchaseType, null: false, description: "The product that was purchased."
  end
end
