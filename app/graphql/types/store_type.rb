module Types
  class StoreType < Types::BaseObject
    field :name, String, null: false, description: "The name of the store."

    field :owner, UserType, null: false, description: "The owner of the store.", 
      resolve: ->(obj, _, _) {
        User.find_by(id: obj.owner_id)
      }
  end
end