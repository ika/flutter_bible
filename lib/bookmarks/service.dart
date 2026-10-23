import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../collections/bible.dart';
import '../collections/bookmark.dart';
import '../database.dart';
import '../globals.dart';

class Bookmark {
  const Bookmark({
    this.id,
    this.localId,
    required this.version,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.text,
  });

  /// Server ID if synced, or fallback to local ID
  final int? id;

  /// Internal Isar local ID
  final int? localId;

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

  factory Bookmark.fromLocal(LocalBookmark local) {
    return Bookmark(
      id: local.serverId ?? local.id,
      localId: local.id,
      version: local.version,
      book: local.book,
      chapter: local.chapter,
      verse: local.verse,
      text: local.text,
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

  /// Performs full bidirectional sync between local Isar cache and remote server.
  /// 1. Pushes any pending local creations and deletions to the remote API.
  /// 2. Fetches remote bookmarks (type 1) and highlights (type 2) and updates local cache.
  Future<void> syncAll() async {
    try {
      await syncPending();
      await _syncFromRemote(1); // Bookmarks
      await _syncFromRemote(2); // Highlights
    } catch (e) {
      debugPrint('BookmarkApi syncAll error: $e');
    }
  }

  /// Adds a bookmark or highlight:
  /// Writes immediately to local Isar cache, then kicks off sync to the remote server.
  Future<void> addBookmark(Bible bible) async {
    final int type = Globals.type;

    // 1. Check local cache to avoid duplicate
    final existing = await isar.localBookmarks
        .filter()
        .versionEqualTo(bible.version)
        .bookEqualTo(bible.book)
        .chapterEqualTo(bible.chapter)
        .verseEqualTo(bible.verse)
        .typeEqualTo(type)
        .not()
        .syncStatusEqualTo(2) // not marked for deletion
        .findFirst();

    if (existing != null) {
      throw BookmarkApiException(
        type == 2
            ? 'This verse is already highlighted.'
            : 'This verse is already bookmarked.',
      );
    }

    // 2. Save locally with pending creation status (1)
    final local = LocalBookmark()
      ..version = bible.version
      ..book = bible.book
      ..chapter = bible.chapter
      ..verse = bible.verse
      ..type = type
      ..text = bible.text
      ..createdAt = DateTime.now()
      ..syncStatus = 1;

    await isar.writeTxn(() async {
      await isar.localBookmarks.put(local);
    });

    // 3. Sync to remote asynchronously in background
    syncPending().ignore();
  }

  /// Gets bookmarks or highlights:
  /// Reads directly and instantly from local Isar cache, while triggering a background sync.
  Future<List<Bookmark>> getBookmarks() async {
    final int type = Globals.type;

    // 1. Read from local cache first (priority to local read)
    final locals = await isar.localBookmarks
        .filter()
        .typeEqualTo(type)
        .not()
        .syncStatusEqualTo(2) // exclude items pending deletion
        .findAll();

    // 2. Trigger remote synchronization in the background
    _syncFromRemote(type).ignore();

    // 3. Return local results immediately
    return locals.map(Bookmark.fromLocal).toList();
  }

  /// Deletes a bookmark or highlight:
  /// Immediately marks/removes locally, then performs deletion on remote server.
  Future<void> deleteBookmark(int id) async {
    if (id <= 0) {
      throw const BookmarkApiException('Invalid bookmark ID.');
    }

    // Find local item by either serverId or localId
    final local = await isar.localBookmarks
        .filter()
        .serverIdEqualTo(id)
        .or()
        .idEqualTo(id)
        .findFirst();

    if (local == null) {
      // Nothing local to delete
      return;
    }

    final serverId = local.serverId;

    // Immediately mark or remove from local cache
    if (serverId == null) {
      // Never made it to server, delete locally immediately
      await isar.writeTxn(() async {
        await isar.localBookmarks.delete(local.id);
      });
      return;
    }

    // Mark as pending deletion (status 2) so it vanishes from UI immediately
    local.syncStatus = 2;
    await isar.writeTxn(() async {
      await isar.localBookmarks.put(local);
    });

    // Sync deletion to remote in background
    _syncDelete(local.id, serverId).ignore();
  }

  /// Syncs all pending local changes (adds & deletes) with the remote API
  Future<void> syncPending() async {
    final pendings = await isar.localBookmarks
        .filter()
        .not()
        .syncStatusEqualTo(0)
        .findAll();

    final client = _client ?? http.Client();

    try {
      for (final item in pendings) {
        if (item.syncStatus == 1) {
          // Pending create
          try {
            final response = await client.post(
              Uri.parse('$BOOKMARK_API_URL/bookmarks'),
              headers: const {'Content-Type': 'application/json'},
              body: jsonEncode({
                'version': item.version,
                'book': item.book,
                'chapter': item.chapter,
                'verse': item.verse,
                'type': item.type,
                'text': item.text,
              }),
            );

            if (response.statusCode == 201) {
              final body = jsonDecode(response.body);
              final key = item.type == 2 ? 'highlight' : 'bookmark';
              final serverData = body[key];
              final serverId = serverData != null
                  ? _asInt(serverData['id'])
                  : null;

              item.serverId = serverId;
              item.syncStatus = 0;
              await isar.writeTxn(() async {
                await isar.localBookmarks.put(item);
              });
            } else if (response.statusCode == 409) {
              // Already exists remotely, mark synced
              item.syncStatus = 0;
              await isar.writeTxn(() async {
                await isar.localBookmarks.put(item);
              });
            }
          } catch (e) {
            debugPrint('Failed to sync pending create for ${item.id}: $e');
          }
        } else if (item.syncStatus == 2 && item.serverId != null) {
          // Pending delete
          try {
            final response = await client.delete(
              Uri.parse('$BOOKMARK_API_URL/bookmarks/${item.serverId}'),
            );
            if (response.statusCode == 204 || response.statusCode == 404) {
              await isar.writeTxn(() async {
                await isar.localBookmarks.delete(item.id);
              });
            }
          } catch (e) {
            debugPrint('Failed to sync pending delete for ${item.id}: $e');
          }
        }
      }
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }

  /// Syncs deletions with remote server
  Future<void> _syncDelete(int localId, int serverId) async {
    final client = _client ?? http.Client();
    try {
      final response = await client.delete(
        Uri.parse('$BOOKMARK_API_URL/bookmarks/$serverId'),
      );
      if (response.statusCode == 204 || response.statusCode == 404) {
        await isar.writeTxn(() async {
          await isar.localBookmarks.delete(localId);
        });
      }
    } catch (e) {
      debugPrint('Error syncing delete for $serverId: $e');
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }

  /// Syncs remote changes into local Isar cache
  Future<void> _syncFromRemote(int type) async {
    final String collection;
    if (type == 1) {
      collection = 'bookmarks';
    } else if (type == 2) {
      collection = 'highlights';
    } else {
      return;
    }

    final client = _client ?? http.Client();

    try {
      final response = await client.get(
        Uri.parse('$BOOKMARK_API_URL/$collection'),
      );

      if (response.statusCode != 200) return;

      final body = jsonDecode(response.body);
      if (body is! Map<String, dynamic>) return;
      final remoteList = body[collection];
      if (remoteList is! List<dynamic>) return;

      final remoteBookmarks = remoteList
          .whereType<Map<String, dynamic>>()
          .map(Bookmark.fromJson)
          .toList();

      for (final rb in remoteBookmarks) {
        final serverId = rb.id;
        if (serverId == null) continue;

        final existing = await isar.localBookmarks
            .filter()
            .serverIdEqualTo(serverId)
            .findFirst();

        if (existing == null) {
          // Check if same item was saved locally without serverId yet
          final matched = await isar.localBookmarks
              .filter()
              .versionEqualTo(rb.version)
              .bookEqualTo(rb.book)
              .chapterEqualTo(rb.chapter)
              .verseEqualTo(rb.verse)
              .typeEqualTo(type)
              .findFirst();

          if (matched != null) {
            matched.serverId = serverId;
            matched.syncStatus = 0;
            await isar.writeTxn(() async {
              await isar.localBookmarks.put(matched);
            });
          } else {
            final newLocal = LocalBookmark()
              ..serverId = serverId
              ..version = rb.version
              ..book = rb.book
              ..chapter = rb.chapter
              ..verse = rb.verse
              ..text = rb.text
              ..type = type
              ..createdAt = DateTime.now()
              ..syncStatus = 0;

            await isar.writeTxn(() async {
              await isar.localBookmarks.put(newLocal);
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Background remote sync error: $e');
    } finally {
      if (_client == null) {
        client.close();
      }
    }
  }

  static int? _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }
}
