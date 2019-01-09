module Types
  class UserAuthenticatePayloadType < Types::BaseObject
    field :user, UserType, null: true, description: "The user that has been authenticated."
  end
end