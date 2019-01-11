# frozen_string_literal: true

module Types
  class StoreType < Types::BaseObject
    field :id, Integer, null: false, description: "The identifier of the store."
    field :name, String, null: false, description: "The name of the store."

    field :owner, UserType, null: false, description: "The owner of the store.",
      resolve: ->(obj, _, _) {
        User.find_by(id: obj.owner_id)
      }

    field :products, [ProductType], null: false, description: "The products sold by the store.",
      resolve: ->(obj, _, _) {
        Product.where(store_id: obj.id)
      }
  end
end
