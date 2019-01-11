# frozen_string_literal: true

module Types
  class UserAuthenticateInputType < Types::BaseInputObject
    argument :email, String, required: true, description: "The email of the user."
    argument :password, String, required: true, description: "The password of the user."
  end
end
