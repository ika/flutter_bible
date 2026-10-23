import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bible/main/page.dart';

import 'bookmarks/preferences.dart';
import 'bookmarks/service.dart';
import 'collections/bible.dart';
import 'collections/booklist.dart';
import 'collections/bookmark.dart';
import 'constants.dart';
import 'database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Directory dir = await getApplicationSupportDirectory();

  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }

  isar = await Isar.open(
    [BibleSchema, BookListSchema, LocalBookmarkSchema],
    name: Constants.isarDatabaseName,
    directory: dir.path,
  );

  for (var entry in Constants.bibleVersionsMap.entries) {
    await ensureVersionLoaded(entry.key);
  }

  await BookmarkPreferences.restoreLastBookmark();

  // Sync local bookmarks/highlights database with remote server on app startup
  const BookmarkApi().syncAll().ignore();

  //-------------------------------------------
  // Check if book list is loaded, if not load it
  //-------------------------------------------
  await ensureBookListLoaded();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: const MainPage(),
    );
  }
}

//-------------------------------------------
// Load a Bible version from assets (assets/{versionCode}.json) and insert verses.
//-------------------------------------------
Future<void> loadBibleVersion(String versionCode) async {
  final path = 'assets/$versionCode.json';
  final jsonString = await rootBundle.loadString(path);
  final List<dynamic> data = jsonDecode(jsonString);

  final verses = data.map((item) {
    return Bible()
      ..version = versionCode
      ..book = item['b']
      ..chapter = item['c']
      ..verse = item['v']
      ..text = item['t'];
  }).toList();

  await isar.writeTxn(() async {
    try {
      await isar.bibles.putAll(verses);
    } catch (e) {
      debugPrint('Error inserting verses: $e');
    }
  });
}

//-------------------------------------------
// Returns whether the specified Bible version has at least the first verse.
//-------------------------------------------
Future<bool> isVersionLoaded(String versionCode) async {
  final count = await isar.bibles
      .filter()
      .versionEqualTo(versionCode)
      .bookEqualTo(1)
      .chapterEqualTo(1)
      .verseEqualTo(1)
      .count();

  return count > 0 ? true : false;
}

Future<void> ensureVersionLoaded(String versionCode) async {
  final bool alreadyLoaded = await isVersionLoaded(versionCode);

  if (!alreadyLoaded) {
    debugPrint('Loading Bible version $versionCode...');
    await loadBibleVersion(versionCode);
  }
}

//-------------------------------------------
// Ensure the book list is loaded: checks existing data and inserts defaults
// from Constants.bibleVersionsMap if missing.
//-------------------------------------------
Future<void> ensureBookListLoaded() async {
  final count = await isBookListLoaded();
  if (count > 0) {
    debugPrint('Book list is already loaded.');
    return;
  }

  debugPrint('Loading book list...');

  final entries = Constants.bibleVersionsMap.entries.map((entry) {
    return BookList()
      ..abbr = entry.key
      ..name = entry.value['name']!
      ..language = entry.value['lang']!
      ..number = int.parse(entry.value['number']!)
      ..active = true;
  }).toList();

  if (entries.isEmpty) {
    debugPrint('No bibleVersions found in Constants.');
    return;
  }

  await isar.writeTxn(() async {
    try {
      await isar.bookLists.putAll(entries);
      debugPrint('Inserted ${entries.length} book list entries.');
    } catch (e) {
      debugPrint('Error inserting book lists: $e');
    }
  });
}

//-------------------------------------------
// Returns whether any book list entries exist in Isar.
//-------------------------------------------
Future<int> isBookListLoaded() async {
  final count = await isar.bookLists.count();
  return count;
}
