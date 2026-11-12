# NOTES

Scope changed once: the first plan was a single country list screen. It is now 3 screens (list, detail, error example) and a learner-facing README. The log below covers both.

## Steps
1. Checked the API: POST `{ countries { name emoji capital } }` to https://countries.trevorblades.com/ returned HTTP 200.
2. `flutter --version`: Flutter 3.47.9 (stable), Dart 3.13.7.
3. `flutter create . --project-name flutter_graphql_exploration --platforms=android,ios`. Output: "Wrote 75 files."
4. `flutter devices` listed only macOS (desktop) and Chrome (web). Ran `flutter create . --project-name flutter_graphql_exploration --platforms=macos`.
5. `flutter analyze` on the unmodified template: "No issues found!"
6. `flutter pub add graphql_flutter --dry-run` resolved. pub.dev API reports latest version 5.3.0 (published 2026-03-14). Package not added yet.
7. Checked the queries for the 3 screens with curl (all HTTP 200):
   - list: `countries { code name emoji }` returned data.
   - detail: `country(code: "ID") { name emoji capital continent { name } languages { name } currency }` returned data. Variable form `query Country($code: ID!)` with `{"code":"JP"}` also returned data.
   - bad field: `countries { code nope }` returned HTTP 200 with body `{"errors":[{"message":"Cannot query field \"nope\" on type \"Country\". Did you mean \"code\" or \"name\"?", ... "extensions":{"code":"GRAPHQL_VALIDATION_FAILED"}}]}` and no `data`.
8. Checked error behavior with the `graphql` Dart package (plain Dart script, outside this repo, not the Flutter widget):
   - bad field: `client.query(...)` did not throw. `hasException=true`, `data=null`, `exception.graphqlErrors` had the message above, `linkException=null`.
   - unreachable host (`http://localhost:1/`): did not throw. `hasException=true`, `linkException` type `ServerException`.

## Problems
- Wrong turn: step 3 generated only android and ios, but no Android/iOS device is connected. Fixed by step 4.
- Folder name `flutter-graphql-exploration` has hyphens, which is not a valid Dart package name. `--project-name` was passed from the start, so the error message was not seen.
- First attempt to create the scratch Dart test project with `dart create` failed silently (no `pubspec.yaml` afterwards). Wrote `pubspec.yaml` by hand instead.

## Surprises
- Step 3 created `test/widget_test.dart` although the scope says no tests. Not deleted yet.
- A GraphQL validation error (bad field) came back as HTTP 200, not 4xx.

## Size
Not measured yet.

## Open questions
- `macos/Runner/DebugProfile.entitlements` has `com.apple.security.network.server` but no `com.apple.security.network.client`. Not tested whether the macOS app can reach the API without it.
- Whether `GraphQLCache()` without `initHiveForFlutter()` works fine in the Flutter app. Not tested (step 8 used the plain Dart package).
- How the `Query` widget (not `client.query`) shows the offline case. Not tested.
- Android and iOS folders were generated but never run. Not tested.
