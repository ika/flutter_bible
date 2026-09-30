import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../collections/bible.dart';
import '../globals.dart';

class Bookmark {
  const Bookmark({
    this.id,
    required this.version,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  final int? id;
  final String version;
  final int book;
  final int chapter;
  final int verse;
  final String text;

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: _asInt(json['id']),
      version: json['version']?.toString() ?? '',
      book: _asInt(json['book']) ?? 0,
      chapter: _asInt(json['chapter']) ?? 0,
      verse: _asInt(json['verse']) ?? 0,
      text: json['text']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'version': version,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': text,
    };
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}

class BookmarkApiException implements Exception {
  const BookmarkApiException(this.message);

  final String message;
}

class BookmarkApi {
  const BookmarkApi({this._client});

  final http.Client? _client;

  Future<void> addBookmark(Bible bible) async {
    final int type = Globals.type;
    final client = _client ?? http.Client();

    try {
      final response = await client.post(
        Uri.parse('$BOOKMARK_API_URL/bookmarks'),
        headers: const {'Content-Type': 'application/json'},
        body: jsonEncode({
          'version': bible.version,
          'book': bible.book,
          'chapter': bible.chapter,
          'verse': bible.verse,
          'type': type,
          'text': bible.text,
        }),
      );

      if (response.statusCode != 201) {
        throw BookmarkApiException(_responseError(response));
      }
    } on http.ClientException {
      throw const BookmarkApiException('Could not reach the bookmark server.');
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }

  Future<List<Bookmark>> getBookmarks() async {
    final int type = Globals.type;
    final String collection = switch (type) {
      1 => 'bookmarks',
      2 => 'highlights',
      _ => throw const BookmarkApiException('Invalid bookmark type.'),
    };
    final client = _client ?? http.Client();

    try {
      final response = await client.get(
        Uri.parse('$BOOKMARK_API_URL/$collection'),
      );

      if (response.statusCode != 200) {
        throw BookmarkApiException(_responseError(response));
      }

      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic>) {
        final bookmarks = body[collection];
        if (bookmarks is List<dynamic>) {
          return bookmarks
              .whereType<Map<String, dynamic>>()
              .map(Bookmark.fromJson)
              .toList();
        }
      }

      throw const BookmarkApiException('Invalid bookmarks response.');
    } on http.ClientException {
      throw const BookmarkApiException('Could not reach the bookmark server.');
    } on FormatException {
      throw const BookmarkApiException('Invalid bookmarks response.');
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }

  Future<void> deleteBookmark(int id) async {
    if (id <= 0) {
      throw const BookmarkApiException('Invalid bookmark ID.');
    }

    final client = _client ?? http.Client();

    try {
      final response = await client.delete(
        Uri.parse('$BOOKMARK_API_URL/bookmarks/$id'),
      );

      if (response.statusCode != 204) {
        throw BookmarkApiException(_responseError(response));
      }
    } on http.ClientException {
      throw const BookmarkApiException('Could not reach the bookmark server.');
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }

  String _responseError(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (body is Map<String, dynamic> && body['error'] is String) {
        return body['error'] as String;
      }
    } on FormatException {
      // Use the HTTP status when the server did not return an API error body.
    }

    return 'Bookmark request failed (${response.statusCode}).';
  }
}
