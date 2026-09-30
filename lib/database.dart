import 'package:isar/isar.dart';

// Re-export the Isar package so any file that imports 'database.dart'
// also gets all the Isar type definitions.
export 'package:isar/isar.dart';

// This global variable will hold your Isar instance.
late Isar isar;