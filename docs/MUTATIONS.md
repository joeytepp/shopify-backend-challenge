# Mutations

As mentioned in the [README](../README.md), this server uses [GraphQL](https://graphql.org) to share information with clients. As is standard with GraphQL, write operations are performed using `mutations`. If you are new to GraphQL I recommend checking out [this guide](https://graphql.org/learn/queries/) to learn more.

> NOTE: For all mutations (except for `userCreate` and `userAuthenticate`) you will need to be [authenticated](./AUTHENTICATION.md) first!

## Creating a resource

For a resource named `foo`, there will be a mutation for `fooCreate` that will create a new `foo` resource. For example, the following mutation

```graphql
mutation {
  storeCreate(input: { name: "Joey's Cool Store" }) {
    store {
      name
    }
  }
}
```

will create a new store called "Joey's Cool Store".

## Updating a resource

For a resource named `foo`, there will be a mutation for `fooUpdate` that will update a new `foo` resource. For example, the following mutation

```graphql
mutation {
  storeUpdate(id: 1, input: { name: "Joey's Cool Store" }) {
    store {
      name
    }
  }
}
```

updates the store with identifier 1 to have the name "Joey's Cool Store"

> Note: You can only do this if you are the owner of this store

## Deleting a resource

For a resource named `bar`, there will be a mutation named `barDelete` that will delete a `bar` resource by identifier. For example, the following mutation

```graphql
mutation {
  storeDelete(id: 1) {
    deletedStoreId
  }
}
```

deletes the store with identifier 1.

> Note: You must be the owner of the store to do this.
