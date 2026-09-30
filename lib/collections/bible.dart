import 'package:isar/isar.dart';

part 'bible.g.dart';

@collection
class Bible {
  Id id = Isar.autoIncrement; // id
  late String version; // Bible version KJV, NIV
  late int book; // book
  late int chapter; // chapter
  late int verse; // verse
  late String text; // text
}
