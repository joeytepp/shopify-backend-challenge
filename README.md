# Shopify Backend Challenge

The annual [Shopify Developer Internship Challenge](https://docs.google.com/document/d/1J49NAOIoWYOumaoQCKopPfudWI_jsQWVKlXmw1f1r-4/edit) for applicants. This year's challenge is to create a basic online store. This respository is my solution, using [Ruby on Rails](https://rubyonrails.org/) and [GraphQL](https://graphql.org).

# Requirements

- Ruby (>=2.5.1)
- Rails (>= 5.2.2)
- PostgreSQL 11

# Usage

To try out the shop for yourself, run the following commands.

`make bootstrap`

> This will install all dependencies and create the local database

`rails s`

> This will start the server

Once the server is running, visit `http://localhost:3000/graphiql`, where [GraphiQL IDE](https://github.com/graphql/graphiql)
is mounted.
