# Queries

As mentioned in the [README](./README.md), this server uses [GraphQL](https://graphql.org) to share information with clients. As is standard with GraphQL, read operations are performed using `queries`. If you are new to GraphQL I recommend checking out [this guide](https://graphql.org/learn/queries/) to learn more.

## Querying for a single resource

For a resource named `foo`, there will be a query called `foo` that will return a single resource by identifier. For example the following query

```graphql
query {
  shop(id: 1) {
    name
  }
}
```

will retrieve the name of the shop with id 1 (null if it doesn't exist)

## Querying for many resources

For a resource named `bar` there will be a query called `bars` that will return all `bar` resources. For example the following query

```graphql
query {
  shops {
    name
  }
}
```

will return all shop resources in the database (or an empty array if none exist)
