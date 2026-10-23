import 'package:isar/isar.dart';

part 'bookmark.g.dart';

@collection
class LocalBookmark {
  Id id = Isar.autoIncrement;

  /// Server record id (from the remote MySQL/SQLite API), null if not yet confirmed.
  int? serverId;

  late String version;
  late int book;
  late int chapter;
  late int verse;
  late String text;

  /// 1 = bookmark, 2 = highlight
  late int type;

  DateTime? createdAt;

  /// Sync status: 0 = synced, 1 = pending create, 2 = pending delete
  int syncStatus = 0;
}
