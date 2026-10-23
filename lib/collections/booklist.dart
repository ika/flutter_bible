import 'package:isar/isar.dart';

part 'booklist.g.dart';

@collection
class BookList {
  Id id = Isar.autoIncrement;
  late String abbr; // version short name
  late String name; // version long name
  late String language; // eng or lat
  late int number; //  number
  late bool active; // yes / no
}
