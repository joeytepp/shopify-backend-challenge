# frozen_string_literal: true

module Types
  class StoreInputType < Types::BaseInputObject
    argument :name, String, required: true
  end
end
