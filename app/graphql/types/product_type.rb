module Types
  class ProductType < Types::BaseObject
    field :id, Integer, null: false, description: "The identifier of the product."
    field :title, String, null: false, description: "The title of the product."
    field :inventory_count, Integer, null: false, description: "The inventory count of the product."
    field :price, Float, null: false, description: "The price of the product"
  end
end