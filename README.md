# GraphQL in Flutter: a small learning repo

A small Flutter app that shows how to use GraphQL with the `graphql_flutter`
package. It is for people who are new to GraphQL in Flutter and want short,
readable examples. It is not a full app.

It uses a public API that needs no token: https://countries.trevorblades.com/

Plain Material widgets only. No code generation, no state management
library, no extra packages.

## How to run

You need Flutter installed.

```
flutter pub get
flutter run -d macos
```

The code was run on macOS only. Other platforms: not tested.

### macOS network permission

On macOS the app needs permission to make outgoing network connections.
Without it, the first screen shows an error like
`SocketException: Connection failed (OS Error: Operation not permitted, errno = 1)`.
This repo already adds `com.apple.security.network.client` in
`macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`.

## The 3 screens

All files are in `lib/`.

### 1. Country list (`country_list_screen.dart`)

Asks for only three fields: `code`, `name` and `emoji`.

**Idea:** in GraphQL you write which fields you want. The country type has
more fields (like `capital` and `currency`), but this screen does not ask for
them, so they are not sent.

### 2. Country detail (`country_detail_screen.dart`)

Tap a country in the list. One query asks for the country, its continent and
its languages together.

**Idea:** related data can be requested in one query. The query also uses a
variable (`$code`), so the same query text works for any country.

Some countries have missing values. For example, Antarctica (`AQ`) has no
capital and no currency, and an empty language list. The screen shows `-` for
these.

### 3. Error example (`error_example_screen.dart`)

Open it with the bug icon in the app bar of the list screen. The query asks
for a field that does not exist (`nope`), so the server rejects it.

**Idea:** GraphQL errors are returned inside the result. They do not throw.
- The `Query` widget shows them through `result.hasException`.
- A `try/catch` around `client.query(...)` does not catch them. The button on
  this screen runs that case so you can see it.

The same happens when the request cannot reach the server (for example no
network): the result has `hasException` set and a `linkException`.

## Where the GraphQL setup is

`lib/main.dart` creates the `GraphQLClient` (an `HttpLink` to the API and an
in-memory `GraphQLCache`) and wraps the app in `GraphQLProvider`. Every
`Query` widget below it uses that client.

## Good for / not good for

These are general points about GraphQL, not measured results from this repo.

Good for:
- Getting data from several sources in one request.
- Fetching only the fields a screen needs.
- A typed schema that describes what you can ask for.

Not so good for:
- Caching is harder than with plain REST.
- Setup is heavier for a small API.
- Errors can come back inside a 200 response, so you must check the result.
- Deep queries can be expensive for the backend.
