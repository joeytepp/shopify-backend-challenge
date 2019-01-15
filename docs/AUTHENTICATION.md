# Authentication

For this server, I used [JSON Web Token (JWT)](https://jwt.io/introduction/) authentication to authenticate users. After running the commands in the [README](../README.md) to set up the environment and start the server. You can authenticate as follows:

## Authenticating An Existing User

The development database willl be seeded with some data, including one user resource. You can authenticate with this using the `userAuthenticate` mutation:

```graphql
# Sign in as tobi@shopify.com
mutation {
  userAuthenticate(
    input: { email: "tobi@shopify.com", password: "password" }
  ) {
    accessToken
  }
}
```

This operation will return a payload that looks as follows:

```json
{
  "data": {
    "userAuthenticate": {
      "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50X3VzZXIiOjF9.OV__7CQIis-mfonp3QILvVhTeCDvqA8B4b1REa5lGls"
    }
  }
}
```

Congratulations, you are now authenticated :tada:! To make an authenticated request, add the following JSON into the `HTTP HEADERS` input in the bottom left corner of GraphQL Playground:

```
  {
    "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJjdXJyZW50X3VzZXIiOjF9.OV__7CQIis-mfonp3QILvVhTeCDvqA8B4b1REa5lGls"
  }
```

and request away!

## Authenticating A New User

To do this, you must first create a new user resource. This is done through the `userCreate` mutation:

```graphql
# Create a new user
mutation {
  userCreate(
    input: {
      firstName: "Joey"
      lastName: "Test"
      email: "joey@yopmail.com"
      password: "password"
      confirmPassword: "password"
    }
  ) {
    user {
      firstName
    }
  }
}
```

> Note: replace the email, password, firstName and lastName with your user's information

This operation will return a payload that looks like:

```json
  "data": {
    "userCreate": {
      "user": {
        "firstName": "Joey"
      }
    }
  }
```

Now that your new user has been created, follow the steps in the section above (Authenticating An Existing User) to get authenticated!

## Configuration

By default, the authentication secret is set to `ABC123`. I do not recommend using this in production. However, this is configurable to something more secure through the `AUTH_SECRET` environment variable.
