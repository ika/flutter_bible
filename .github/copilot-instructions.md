# Flutter Bible repository instructions

## Commands

Run commands from the repository root:

```sh
flutter pub get
flutter analyze
flutter test
flutter test test/path/to/widget_test.dart
flutter build apk
flutter build linux
```

There is currently no `test/` directory. Add targeted tests under `test/`, then
run the individual test file with `flutter test test/path/to/test_file.dart`.

The Isar collection in `lib/collections/bible.dart` has generated code. After
changing an `@collection` model, regenerate it with:

```sh
dart run build_runner build --delete-conflicting-outputs
```

## Architecture

- The application starts in `lib/main.dart`. It opens the Isar database in the
  application-support directory, loads every version declared in
  `Constants.bibleVersionsMap` from `assets/<version>.json` when absent, restores
  the last bookmarked location, and only then calls `runApp`.
- Bible verses are stored locally in the `Bible` Isar collection. Verse JSON
  uses `b`, `c`, `v`, and `t` fields, which are mapped to `book`, `chapter`,
  `verse`, and `text` respectively.
- `lib/main/page.dart` is the UI coordinator. It is split with Dart `part`
  files for the menu, selectors, search, bookmarks, version picker, verse
  actions, and comparison sheets. Those files intentionally use
  `part of 'page.dart'` and share its private types and imports.
- `Globals` is the shared navigation state: selected version, language, book,
  chapter, verse, and the current collection type. `MainPageState` reads that
  state to query Isar and render the selected chapter.
- Bookmarks and highlights are remote data handled by
  `lib/bookmarks/service.dart`. The endpoint is configured by
  `BOOKMARK_API_URL` in `lib/constants.dart`. Bookmark selection and last
  location persistence are separate: the latter uses `SharedPreferences` in
  `lib/bookmarks/preferences.dart`.

## Repository conventions

- Keep every Bible version aligned across `Constants.bibleVersionsMap`, the
  `assets/` declaration in `pubspec.yaml`, and its `assets/<version>.json`
  file. The startup loader relies on the map key being the asset basename and
  the Isar `version` value.
- Do not manually edit `lib/collections/bible.g.dart`; regenerate it after
  model changes.
- A bottom sheet that changes the passage returns `true` with
  `Navigator.pop(context, true)`. The presenting method in `MainPageState`
  awaits that result and calls `_refreshAfterSelection()`. Preserve this flow;
  do not construct `MainPageState` manually.
- New bottom sheets follow the existing presentation style: `SafeArea` with
  `top: false`, a rounded top surface, height constrained to 80% of the
  viewport, and `_BottomSheetDragHandle` above scrollable content.
- Isar reads are version-scoped using `Globals.bibleVersionName`. When a
  selection changes version, update `Globals.bibleVersionLanguage` as well.
- `BookmarkApi` accepts an optional `http.Client` for testability. Preserve
  its ownership rule: callers supplying a client own it; internally created
  clients are closed in `finally`.
- The Android build uses Java 17. Keep the root Gradle workaround for
  `isar_flutter_libs` (`namespace` and `compileSdk = 36`) unless the dependency
  is upgraded and the workaround is verified unnecessary.
