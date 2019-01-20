# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
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

    field :products, [ProductType], null: false, description: "Returns all product resources." do
      argument :available, Boolean, required: false, description: "Restricts the response to products that are available for purchase."
    end

    field :cart, CartType, null: true, description: "Returns a cart resource by identifier" do
      argument :id, Integer, required: true, description: "The identifier of the cart."
    end

    field :carts, [CartType], null: false, description: "Returns all cart resources"

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

    def product(args)
      Product.find_by(id: args[:id])
    end

    def products(args = {})
      if args[:available]
        return Product.where("inventory_count > 0")
      end

      Product.all
    end

    def carts
      Cart.all
    end

    def cart(args)
      Cart.find_by(id: args[:id])
    end
  end
end
