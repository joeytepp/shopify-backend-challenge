# frozen_string_literal: true

require "test_helper"
require "json"

class QueryTest < ActionDispatch::IntegrationTest
  test "userCreate mutation" do
    post "/graphql", params: {
      operation_name: nil,
      query: "
        mutation {
          userCreate(
            input: {
              firstName: \"Joey\"
              lastName: \"Tepperman\"
              email: \"plzhireme@shopfiy.com\"
              password: \"secret\"
              confirmPassword: \"secret\"
            }) {
              user {
                firstName
              }
            }
        }
      ",
      variables: {}
    }

    res = JSON.parse(response.body)
    user = res["data"]["userCreate"]["user"]

    assert_equal({ "firstName" => "Joey" }, user)

    new_user = User.find_by(email: "plzhireme@shopfiy.com")
    assert_equal "Joey", new_user.first_name
  end

  test "userAuthenticate mutation" do
    post "/graphql", params: {
      operation_name: nil,
      query: "
        mutation {
          userAuthenticate(
            input: {
              email: \"tobi@shopify.com\"
              password: \"password\"
            }) {
              accessToken
            }
        }
      ",
      variables: {}
    }

    res = JSON.parse(response.body)
    token = res["data"]["userAuthenticate"]["accessToken"]

    assert_not_nil token
  end
end
