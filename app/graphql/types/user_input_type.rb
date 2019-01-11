module Types
  class UserInputType < Types::BaseInputObject
    argument :first_name, String, required: true, description: "The first name of the new user."
    argument :last_name, String, required: true, description: "The last name of the new user."
    argument :email, String, required: true, description: "The email of the new user."
    argument :password, String, required: true, description: "The password of the new user."
    argument :confirm_password, String, required: true, description: "The password confirmation of the new user."
  end
end
