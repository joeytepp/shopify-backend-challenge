module Types
  class MutationType < Types::BaseObject
    # TODO: remove me
    field :user_create, UserCreatePayloadType, null: false, description: "Creates a new user." do
      argument :input, UserCreateInputType, required: true, description: "The payload of the userCreate mutation."
    end

    field :user_authenticate, UserAuthenticatePayloadType, null: false, description: "Authenticates a user." do
      argument :input, UserAuthenticateInputType, required: true, description: "The payload of the userAuthenticate mutation"
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
      user.authenticate(args[:password])

      $CURRENT_USER = user

      { user: user }
    end
  end
end
