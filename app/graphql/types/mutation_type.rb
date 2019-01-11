module Types
  class MutationType < Types::BaseObject
    field :user_create, UserCreatePayloadType, null: false, description: "Creates a new user." do
      argument :input, UserInputType, required: true, description: "The payload of the userCreate mutation."
    end

    field :user_authenticate, UserAuthenticatePayloadType, null: false, description: "Authenticates a user." do
      argument :input, UserAuthenticateInputType, required: true, description: "The payload of the userAuthenticate mutation"
    end

    field :store_create, StoreCreatePayloadType, null: false, description: "Creates a new store." do
      argument :input, StoreInputType, required: true, description: "The store that will be created."
    end

    field :store_update, StoreUpdatePayloadType, null: false, description: "Updates an existing store." do
      argument :store_id, Integer, required: true, description: "The identifier of the store."
      argument :input, StoreInputType, required: true, description: "The updated store."
    end

    field :store_delete, StoreDeletePayloadType, null: false, description: "Deletes a store." do
      argument :id, Integer, required: true, description: "The identifier of the store."
    end

    field :product_create, ProductCreatePayloadType, null: false, description: "Creates a new product." do
      argument :store_id, Integer, required: true, description: "The identifier of the product's store."
      argument :input, ProductInputType, required: true, description: "The product that will be created."
    end

    field :product_update, ProductCreatePayloadType, null: false, description: "Creates a new product." do
      argument :product_id, Integer, required: true, description: "The identifier of the product to be updated."
      argument :input, ProductInputType, required: true, description: "The product that will be updated."
    end

    field :product_delete, ProductDeletePayloadType, null: false, description: "Deletes a product." do
      argument :id, Integer, required: true, description: "The identifier of the product."
    end

    field :purchase_create, PurchaseCreatePayloadType, null: false, description: "Creates a new purchase." do
      argument :input, PurchaseInputType, required: true, description: "The purchase that will be created."
    end

    field :purchase_delete, PurchaseDeletePayloadType, null: false, description: "Deletes a product." do
      argument :id, Integer, required: true, description: "The identifier of the product."
    end

    def user_create(args)
      input = args[:input]

      user = User.new(
        first_name: input.first_name,
        last_name: input.last_name,
        email: input.email,
        password: input.password,
        password_confirmation: input.confirm_password
      )

      user.save!

      $CURRENT_USER = user

      { user: user }
    end

    def user_authenticate(args)
      user = User.find_by(email: args[:input].email)
      auth_success = user.authenticate(args[:input].password)

      if auth_success
        $CURRENT_USER = user
        { user: user }
      else
        raise "Incorrect password provided!"
      end
    end

    def store_create(args)
     is_authenticated

      input = args[:input]

      store = Store.new(name: input.name, owner_id: $CURRENT_USER.id)
      store.save!

      { store: store }
    end

    def store_update(args)
      is_authenticated

      input = args[:input]
      store_id = args[:store_id]

      store = Store.find_by(id: store_id)

      unless store
        raise "Unable to find store with identifier #{store_id}"
      end

      is_owner(store.owner_id)

      updated_store = Store.update(store_id, { :name => input.name })

      { store: updated_store }
    end

    def store_delete(args)
      is_authenticated

      store = Store.find_by(id: args[:id])

      unless store then raise "Unable to find the store with the identifier #{args[:id]}" end

      is_owner(store.owner_id)

      store.destroy!

      { deleted_store_id: store.id }
    end

    def product_create(args)
     is_authenticated

      input = args[:input]
      store_id = args[:store_id]

      store = Store.find_by(id: store_id)

      unless store
        raise "Unable to find store with identifier #{store_id}"
      end

      is_owner(store.owner_id)

      product = Product.new(
        title: input.title,
        inventory_count: input.inventory_count,
        price: input.price,
        store_id: store_id
      )

      product.save!

      { product: product }
    end

    def product_update(args)
      is_authenticated

      input = args[:input]
      product_id = args[:product_id]

      product = Product.find_by(id: product_id)

      unless product
        raise "Unable to find product with identifier #{product_id}."
      end

      store = Store.find_by(id: product.store_id)

      is_owner(store.owner_id)

      product = Product.update(
        product_id,
        {
          :title => input.title,
          :inventory_count => input.inventory_count,
          :price => input.price
        }
      )

      { product: product }
    end

    def product_delete(args)
      is_authenticated

      product = Product.find_by(id: args[:id])

      unless product then raise "Unable to find the product with identifier #{args[:id]}" end

      store = Store.find_by(id: product.store_id)

      is_owner(store.owner_id)

      product.destroy!

      { deleted_product_id: product.id }
    end

    def purchase_create(args)
     is_authenticated

      input = args[:input]

      product = Product.find_by(id: input.product_id)

      unless product
        raise "Could not find the product with identifier #{input.product_id}"
      end

      product.inventory_count -= input.quantity

      unless product.inventory_count > -1
        raise "Cannot purchase #{input.quantity} #{product.title}s at this time."
      end

      purchase = Purchase.create(user_id: $CURRENT_USER.id, product_id: product.id, quantity: input.quantity)

      purchase.save!
      product.save!

      { purchase: purchase }
    end

    def purchase_delete(args)
      is_authenticated

      purchase = Purchase.find_by(id: args[:id])

      unless purchase
        raise "Unable to find purchase with identifier #{args[:id]}"
      end

      is_owner(purchase.user_id)

      product = Product.find_by(id: purchase.product_id)
      product.inventory_count = product.inventory_count + purchase.quantity.to_i

      purchase.destroy!
      product.save!

      { deleted_purchase_id: purchase.id }
    end

    private

    def is_authenticated
      unless $CURRENT_USER
        raise "Must be authenticated to perform this action!"
      end
    end

    def is_owner(id)
      unless id == $CURRENT_USER.id
        raise "Must be the owner of this resource to perform this operation!"
      end
    end
  end
end
