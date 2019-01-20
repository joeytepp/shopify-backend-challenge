# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :user_create, UserCreatePayloadType, null: false, description: "Creates a new user." do
      argument :input, UserInputType, required: true, description: "The user that will be created."
    end

    field :user_authenticate, UserAuthenticatePayloadType, null: false, description: "Authenticates a user." do
      argument :input, UserAuthenticateInputType, required: true, description: "The user that will be authenticated."
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

    field :purchase_delete, PurchaseDeletePayloadType, null: false, description: "Deletes a purchase (ie. a refund)." do
      argument :id, Integer, required: true, description: "The identifier of the product."
    end

    field :cart_create, CartCreatePayloadType, null: false, description: "Creates a cart."

    field :cart_delete, CartDeletePayloadType, null: false, description: "Deletes a cart." do
      argument :id, Integer, required: true, description: "The identifier of the cart."
    end

    field :cart_check_out, CartCheckOutPayloadType, null: false, description: "Checks out a cart." do
      argument :id, Integer, required: true, description: "The identifier of the cart."
    end

    field :product_add_to_cart, ProductAddToCartPayloadType, null: false, description: "Adds a product to a cart." do
      argument :input, ProductCartInputType, required: true, description: "The input for adding a product to a cart."
    end

    field :product_remove_from_cart, ProductRemoveFromCartPayloadType, null: false, description: "Removes a product from a cart." do
      argument :input, ProductCartInputType, required: true, description: "The input for removing a prdocut from a cart."
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

      { user: user }
    end

    def user_authenticate(args)
      user = User.find_by(email: args[:input].email)

      unless user then raise "Could not find user with email #{args[:input].email}" end

      auth_success = user.authenticate(args[:input].password)

      if auth_success
        payload = { current_user: user.id, exp: Time.now.to_i + 3600 }
        access_token = JWT.encode payload, ENV["AUTH_SECRET"] || "ABC123", "HS256"
        { access_token: access_token }
      else
        raise "Incorrect password provided!"
      end
    end

    def store_create(args)
      is_authenticated

      input = args[:input]

      store = Store.new(name: input.name, owner_id: context[:current_user])
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

      updated_store = Store.update(store_id, name: input.name)

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
          title: input.title,
          inventory_count: input.inventory_count,
          price: input.price
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

    def cart_create
      is_authenticated

      cart = Cart.new(user_id: context[:current_user], checked_out: false)
      cart.save!

      { cart: cart }
    end

    def cart_delete(args)
      is_authenticated

      cart = Cart.find_by(id: args[:id])

      raise "Unable to find the cart with identifier #{args[:id]}" unless cart

      is_owner(cart.user_id)

      cart.destroy!

      { deleted_cart_id: cart.id }
    end

    def cart_check_out(args)
      is_authenticated

      cart = Cart.find_by(id: args[:id])

      raise "Unable to find the cart with identifier #{args[:id]}!" unless cart

      if cart.checked_out
        raise "The cart with identifier #{args[:id]} has already been checked out!"
      end
      is_owner(cart.user_id)

      products = cart.products

      products.each do |product|
        product.inventory_count -= 1
        if product.inventory_count < 0
          raise "#{product.title} can't be purchased at this time, please remove it from your cart."
        end
      end

      Product.transaction do
        purchases_map = {}

        products.each do |product|
          product.save!
          if purchases_map[product.id].nil?
            purchases_map[product.id] = 1
          else
            purchases_map[product.id] += 1
          end
        end

        purchases_map.each do |product_id, quantity|
          Purchase.new(product_id: product_id, user_id: context[:current_user], quantity: quantity).save!
        end

        cart.checked_out = true
        cart.save!
      rescue
        raise "Unable to check out cart at this time."
      end

      { checked_out_cart_id: cart.id }
    end

    def product_add_to_cart(args)
      is_authenticated

      input = args[:input]
      cart = Cart.find_by(id: input.cart_id)

      raise "Unable to find the cart with identifier #{input.cart_id}!" unless cart

      is_owner cart.user_id

      product = Product.find_by(id: input.product_id)

      raise "Unable to find the product with identifier #{input.product_id}" unless product

      cart_product = CartProduct.create(input.to_h)
      cart_product.save!

      { product: product }
    end

    def product_remove_from_cart(args)
      is_authenticated

      input = args[:input]
      cart = Cart.find_by(id: input.cart_id)

      raise "Unable to find the cart with identifier #{input.cart_id}." unless cart

      raise "The cart with identifier #{input.cart_id} has already been checked out" if cart.checked_out

      is_owner(cart.user_id)

      product = Product.find_by(id: input.product_id)

      raise "Unable to find the the product with identifier #{input.product_id}." unless product

      cart_product = CartProduct.find_by(cart_id: input.cart_id, product_id: input.product_id)

      raise "The product with identifier #{input.product_id} is not present in the cart with identifier #{input.cart_id}." unless cart_product

      cart_product.destroy!

      { product: product }
    end


    private

      def is_authenticated
        current_user = context[:current_user]

        unless current_user
          raise "Must be authenticated to perform this action!"
        end
      end

      def is_owner(id)
        current_user = context[:current_user]
        unless id == current_user
          raise "Must be the owner of this resource to perform this operation!"
        end
      end
  end
end
