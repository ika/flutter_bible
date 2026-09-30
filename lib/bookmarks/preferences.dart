import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../collections/bible.dart';
import '../constants.dart';
import '../globals.dart';
import '../langs/books.dart';

class BookmarkPreferences {
  static const _lastBookmarkKey = 'last_bookmark';

  static Future<void> saveLastBookmark(Bible bible) async {
    final preferences = await SharedPreferences.getInstance();
    final saved = await preferences.setString(
      _lastBookmarkKey,
      jsonEncode({
        'version': bible.version,
        'book': bible.book,
        'chapter': bible.chapter,
        'verse': bible.verse,
      }),
    );

    if (!saved) {
      throw StateError('Could not save the last bookmark.');
    }
  }

  static Future<void> restoreLastBookmark() async {
    final preferences = await SharedPreferences.getInstance();
    final savedBookmark = preferences.getString(_lastBookmarkKey);
    if (savedBookmark == null) {
      return;
    }

    try {
      final bookmark = jsonDecode(savedBookmark);
      if (bookmark is! Map<String, dynamic>) {
        throw const FormatException('Last bookmark must be a JSON object.');
      }

      final version = bookmark['version'];
      final book = bookmark['book'];
      final chapter = bookmark['chapter'];
      final verse = bookmark['verse'];

      if (version is! String ||
          !Constants.bibleVersionsMap.containsKey(version) ||
          book is! int ||
          chapter is! int ||
          verse is! int ||
          book <= 0 ||
          chapter <= 0 ||
          verse <= 0) {
        throw const FormatException('Last bookmark contains invalid values.');
      }

      Globals.bibleVersionName = version;
      Globals.bibleVersionLanguage =
          Constants.bibleVersionsMap[version]!['lang'] ?? 'eng';
      Globals.bibleBookNumber = book;
      Globals.bibleBookName = BibleBooks.getBookNameByNumber(book);
      Globals.bibleChapterNumber = chapter;
      Globals.bibleVerseNumber = verse;
    } on FormatException catch (exception) {
      debugPrint('Discarding invalid last bookmark: $exception');
      await preferences.remove(_lastBookmarkKey);
    }
  }
}
