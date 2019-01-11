module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :user, UserType, null: true,
      description: "Returns a user resource by identifier." do
        argument :id, Integer, required: true, description: "The identifier of the user."
      end

    field :users, [UserType], null: false, description: "Returns all user resources."

    field :store, StoreType, null: true, description: "Returns a store resource by identifier." do
      argument :id, Integer, required: true, description: "The identifier of the store."
    end

    field :stores, [StoreType], null: false, description: "Returns all the store resources."

    field :product, ProductType, null: true, description: "Returns a product resource by identifier." do
      argument :id, Integer, required: true, description: "The identifier of the store."
    end

    field :products, [ProductType], null: false, description: "Returns all product resources."

    def user(args)
      User.find_by(id: args[:id])
    end

    def users
      User.all
    end

    def store(args)
      Store.find_by(id: args[:id])
    end

    def stores
      Store.all
    end

    def product
      Product.find_by(id: args[:id])
    end

    def products
      Product.all
    end
  end
end
