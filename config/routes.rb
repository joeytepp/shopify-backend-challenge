# frozen_string_literal: true

Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"

  if Rails.env.development?
    mount GraphqlPlayground::Rails::Engine, at: "/playground", graphql_path: "/graphql"
  end

  get "*path", to: redirect("/playground")
end
