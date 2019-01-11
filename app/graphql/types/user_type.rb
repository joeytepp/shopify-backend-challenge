module Types
  class UserType < Types::BaseObject
    field :id, Integer, null: false, description: "The identifier of the user."
    field :first_name, String, null: false, description: "The first name of the user."
    field :last_name, String, null: false, description: "The last name of the user."
    field :email, String, null: false, description: "The email of the user."

    field :stores, [StoreType], null: false, description: "The stores owned by the user.", 
      resolve: ->(obj, _, _) {
        Store.where(owner_id: obj.id)
      }
  end
end
