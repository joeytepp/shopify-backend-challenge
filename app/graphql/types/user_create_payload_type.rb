# frozen_string_literal: true

module Types
  class UserCreatePayloadType < Types::BaseObject
    field :user, UserType, null: true, description: "The newly created user."
  end
end
