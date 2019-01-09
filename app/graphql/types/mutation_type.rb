module Types
  class MutationType < Types::BaseObject
    field :user_create, UserCreatePayloadType, null: false, description: "Creates a new user." do
      argument :input, UserCreateInputType, required: true, description: "The payload of the userCreate mutation."
    end

    field :user_authenticate, UserAuthenticatePayloadType, null: false, description: "Authenticates a user." do
      argument :input, UserAuthenticateInputType, required: true, description: "The payload of the userAuthenticate mutation"
    end

    field :store_create, StoreCreatePayloadType, null: false, description: "Creates a new store." do
      argument :input, StoreInputType, required: true, description: "The store that will be created."
    end

    field :store_update, StoreUpdatePayloadType, null: false, description: "Updates an existing store." do
      argument :store_id, Integer, required: true, description: "The identifier of the store."
      argument :input, StoreInputType, required: true, description: "The updated store"
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
      unless $CURRENT_USER
        raise "Must be authenticated to perform this action!"
      end

      input = args[:input]

      store = Store.new(name: input.name, owner_id: $CURRENT_USER.id)
      store.save!

      { store: store }
    end

    def store_update(args)
      unless $CURRENT_USER
        raise "Must be authenticated to perform this action!"
      end

      input = args[:input]
      store_id = args[:store_id]

      store = Store.find_by(id: store_id)

      unless store
        raise "Unable to find store!"
      end

      unless store.owner_id == $CURRENT_USER.id
        raise "Must be owner of store to update!"
      end

      updated_store = Store.update(store_id, { :name => input.name })

      { store: updated_store }
    end
  end
end
