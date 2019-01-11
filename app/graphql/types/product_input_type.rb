# frozen_string_literal: true

module Types
  class ProductInputType < Types::BaseInputObject
    argument :title, String, required: true, description: "The title of the product."
    argument :inventory_count, Integer, required: true, description: "The inventory count of the product."
    argument :price, Float, required: true, description: "The price of the prouduct."
  end
end
