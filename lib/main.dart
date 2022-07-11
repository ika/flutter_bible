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

  utilities.setDialogeHeight();

  // read bible version - needed early
  _sharedPrefs.readVersion().then(
    (v) {
      Globals.bibleVersion = v;
      //read book
      _sharedPrefs.readBook().then(
        (v) {
          Globals.bibleBook = v;
          //read language
          _sharedPrefs.readLang().then(
            (v) {
              Globals.bibleLang = v;
              runApp(
                const BibleApp(),
              );
            },
          );
        },
      );
    },
  );
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
