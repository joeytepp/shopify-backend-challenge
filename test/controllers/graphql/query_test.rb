# frozen_string_literal: true

require "test_helper"
require "json"

class QueryTest < ActionDispatch::IntegrationTest
  test "users query" do
    post "/graphql", params: {
      operation_name: nil,
      query: "
        {
          users {
            firstName
            lastName
            email
          }
        }
      ",
      variables: {}
    }

    res = JSON.parse(response.body)
    users = res["data"]["users"]

    assert_equal({
      "firstName" => "Tobias",
      "lastName" => "Lütke",
      "email" => "tobi@shopify.com"
    }, users[0])

    assert_equal({
      "firstName" => "Lee",
      "lastName" => "Byron",
      "email" => "lee@graphql.org"
    }, users[1])
  end

  test "user query" do
    post "/graphql", params: {
      operation_name: nil,
      query: "
        {
          user(id: 1) {
            firstName
            lastName
            email
          }
        }
      ",
      variables: {}
    }

    res = JSON.parse(response.body)
    user = res["data"]["user"]

    assert_equal({
      "firstName" => "Tobias",
      "lastName" => "Lütke",
      "email" => "tobi@shopify.com"
    }, user)
  end

  test "stores query" do
    post "/graphql", params: {
      operation_name: nil,
      query: "
        {
          stores {
            name
            owner {
              firstName
            }
          }
        }
      ",
      variables: {}
    }

    res = JSON.parse(response.body)
    stores = res["data"]["stores"]

    assert_equal({
      "name" => "Tobi's Snowboard Store",
      "owner" => { "firstName" => "Tobias" }
    }, stores[0])

    assert_equal({
      "name" => "Lee's Graph Store",
      "owner" => { "firstName" => "Lee" }
    }, stores[1])
  end
end
