# frozen_string_literal: true

module Types
  class PurchaseInputType < Types::BaseInputObject
    argument :product_id, Integer, required: true, description: "The identifier of the product to be purchased."
    argument :quantity, Integer, required: true, description: "The quantity of the product that will be purchased."
  end
end
