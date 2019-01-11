module Types
  class UserAuthenticatePayloadType < Types::BaseObject
    field :access_token, String, null: true, description: "The access token for the authenticated user."
  end
end