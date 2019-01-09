module Types
  class UserType < Types::BaseObject
    field :first_name, String, null: false, description: "The first name of the user."
    field :last_name, String, null: false, description: "The last name of the user."
    field :email, String, null: false, description: "The email of the user."
  end
end
