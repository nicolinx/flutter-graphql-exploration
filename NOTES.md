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
9. `flutter pub add graphql_flutter`: added as `graphql_flutter: ^5.3.0` in `pubspec.yaml`.
10. Deleted `test/widget_test.dart` (scope says no tests).
11. Wrote `lib/main.dart` (client with `HttpLink` + `GraphQLCache()`, `GraphQLProvider` around `MaterialApp`) and `lib/country_list_screen.dart` (query for `code name emoji`, `Query` widget, `ListView.builder`).
12. First run on macOS: the screen showed the exception text below instead of the list (see Problems).
13. Added `com.apple.security.network.client` set to `true` in `macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`, then restarted the app. The country list then showed.
14. Wrote `lib/country_detail_screen.dart` (query with `$code` variable, nested `continent` and `languages`) and `lib/error_example_screen.dart` (bad field `nope`, `Query` widget plus `client.query` in `try/catch`). The list screen got an `onTap` to the detail screen and a bug icon in the app bar to the error screen.
15. `flutter analyze`: "No issues found!"
16. Rewrote `README.md` for learners.

## Problems
- Wrong turn: step 3 generated only android and ios, but no Android/iOS device is connected. Fixed by step 4.
- Folder name `flutter-graphql-exploration` has hyphens, which is not a valid Dart package name. `--project-name` was passed from the start, so the error message was not seen.
- First run on macOS showed this on screen (shown via `result.exception.toString()` in the `Query` builder, not a crash):
  `OperationException(linkException: ServerException(originalException: ClientException with SocketException: Connection failed (OS Error: Operation not permitted, errno = 1), address = countries.trevorblades.com, port = 443, uri=https://countries.trevorblades.com/ ...), parsedResponse: null), graphqlErrors: [])`
  At that time `DebugProfile.entitlements` had `com.apple.security.network.server` and no `network.client`. Adding `network.client` to both entitlements files and fully restarting fixed it. Not tested: whether only one of the two files is needed, or whether hot restart alone would have been enough.
- First attempt to create the scratch Dart test project with `dart create` failed silently (no `pubspec.yaml` afterwards). Wrote `pubspec.yaml` by hand instead.

## Surprises
- Step 3 created `test/widget_test.dart` although the scope says no tests. Deleted in step 10.
- The country list did not scroll when dragging with the mouse on macOS. Scrolling worked with the other input method (trackpad or mouse wheel). The code (`ListView.builder`) was not changed.
- A network failure on macOS appeared as exception text in the UI (`result.hasException`), not as a crash.
- The editor generated constructors written as `const new({super.key})` (Dart `new` constructor syntax). `flutter analyze` reports no issues with it.
- A GraphQL validation error (bad field) came back as HTTP 200, not 4xx.

## Size
`wc -l lib/*.dart`, 260 lines in total:
- `lib/main.dart`: 27 (client + provider + app)
- `lib/country_list_screen.dart`: 73 (query + UI + navigation)
- `lib/country_detail_screen.dart`: 79 (query + UI)
- `lib/error_example_screen.dart`: 81 (bad query + UI + try/catch demo)
Line counts include comments and the blank lines added by the formatter.

## Open questions
- The list screen loaded with `GraphQLCache()` and no `initHiveForFlutter()`. Not tested: whether anything differs (for example persistence between app restarts).
- Why dragging with the mouse does not scroll on macOS. Not checked in the Flutter docs.
- Result of running the detail screen and the error screen in the app: not recorded here.
- How the `Query` widget (not `client.query`) shows the offline case. Not tested.
- The README says the same `hasException` result happens when the server is unreachable. Verified only with the plain Dart `graphql` package (step 8), not in the app.
- The app was run on macOS only. Chrome, Android and iOS: not tested.
- Android and iOS folders were generated but never run. Not tested.
