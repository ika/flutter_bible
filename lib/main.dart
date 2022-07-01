import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/main/mainPage.dart';
import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:digitalbibleapp/utils/utilities.dart';
import 'package:flutter/material.dart';

// int v = 0; // = 1; // bible version number, e.g. KJV = 1
// int b = 0; // = 43; // John = 43
// int c = 0; // = 1; // chapter
// String l = ''; // language code
// String n = ''; // book name
// String r = ''; // book abbreviation

// LkQueries _lkQueries = LkQueries();
// VkQueries _vkQueries = VkQueries();

SharedPrefs _sharedPrefs = SharedPrefs();
Utilities utilities = Utilities();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _sharedPrefs.readVersion().then(
    (v) {
      Globals.bibleVersion = v;
      utilities.setDialogeHeight();
      runApp(const BibleApp());
    },
  );

  // Future<String> getLanguageBookName(b, l) async {
  //   List<LKey> value = List<LKey>.empty();
  //   value = await _lkQueries.getBookName(b, l);
  //   return value.first.n;
  // }

  // Future<String> readVersionKey(int v) async {
  //   List<VkModel> value = List<VkModel>.empty();
  //   value = await _vkQueries.getVersionKey(v);
  //   String r = value.first.r; // abbreviation
  //   String l = value.first.l; // language
  //   return "$r|$l";
  // }

  // sharedPrefs.readVersionData().then(
  //   (value) async {
  //     var parts = value.split('|');
  //     v = int.parse(parts[0]); // 1 - Kjv
  //     b = int.parse(parts[1]); // 43 - Gospel of John
  //     c = int.parse(parts[2]); // 1 - chapter 1

  //     String verKeys = await readVersionKey(v);
  //     var vKeys = verKeys.split('|');
  //     r = vKeys[0]; // bible version abbreviation
  //     l = vKeys[1]; // language
  //     n = await getLanguageBookName(b, l);

  //     runApp(const BibleApp());
  //   },
  // );
}

class BibleApp extends StatelessWidget {
  const BibleApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bible App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPageCall(),
    );
  }
}
