# frozen_string_literal: true

module Types
  class PurchaseType < Types::BaseObject
    field :id, Integer, null: false, description: "The identifier of the purchase."
    field :product, ProductType, null: false, description: "The product that was purchased.",
    resolve: ->(obj, _, _) {
      Product.find_by(id: obj.product_id)
    }

    field :quantity, Integer, null: false, description: "The quantity of the product."
  end
end
