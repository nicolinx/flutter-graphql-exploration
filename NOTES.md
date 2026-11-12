# NOTES

## Steps
1. Checked the API: POST `{ countries { name emoji capital } }` to https://countries.trevorblades.com/ returned HTTP 200.
2. `flutter --version`: Flutter 3.47.9 (stable), Dart 3.13.7.
3. `flutter create . --project-name flutter_graphql_exploration --platforms=android,ios` in the project folder. Output: "Wrote 75 files."
4. `flutter devices` listed only macOS (desktop) and Chrome (web). Ran `flutter create . --project-name flutter_graphql_exploration --platforms=macos` to add the macOS runner.
5. `flutter analyze` on the unmodified template: "No issues found!"
6. `flutter pub add graphql_flutter --dry-run` resolved. pub.dev API reports latest version 5.3.0 (published 2026-03-14). Package not added yet.

## Problems
- Wrong turn: step 3 generated only android and ios, but no Android/iOS device is connected, so the app could not run on them. Fixed by step 4.
- Folder name `flutter-graphql-exploration` has hyphens, which is not a valid Dart package name. `flutter create` needed `--project-name flutter_graphql_exploration`. The error message itself was not seen, because the flag was passed from the start.

## Surprises
- Step 3 created `test/widget_test.dart` although the scope says no tests. Not deleted yet.

## Size
Not measured yet.

## Open questions
- `macos/Runner/DebugProfile.entitlements` has `com.apple.security.network.server` but no `com.apple.security.network.client`. Not tested whether the macOS app can reach the API without adding it.
- Whether `GraphQLCache()` without `initHiveForFlutter()` works fine here. Not tested.
- The generated `test/widget_test.dart` references the template counter app. Not checked whether it breaks after `main.dart` is replaced.
- Android and iOS folders were generated but never run. Not tested.
