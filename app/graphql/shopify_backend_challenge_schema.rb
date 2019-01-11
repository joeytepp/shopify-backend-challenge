# frozen_string_literal: true

class ShopifyBackendChallengeSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
