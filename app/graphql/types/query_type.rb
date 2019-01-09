module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :user, UserType, null: true,
      description: "Returns a user resource by identifier." do
        argument :id, String, required: true, description: "The identifier of a user"
      end

    field :users, [UserType], null: false, description: "Returns all user resources."

    def user(args)
      User.find_by(id: args[:id])
    end

    def users
      User.all
    end
  end
end
