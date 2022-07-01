import 'package:digitalbibleapp/langs/lkModel.dart';
import 'package:digitalbibleapp/langs/lkQueries.dart';
import 'package:shared_preferences/shared_preferences.dart';

LkQueries _lkQueries = LkQueries(); // language key

class SharedPrefs {
  SharedPreferences _sharedPreferences;

  Future<SharedPreferences> initInstance() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences;
  }

  Future<String> getLanguageBookName(b, l) async {
    List<LKey> value = List<LKey>.empty();
    value = await _lkQueries.getBookName(b, l);
    return value.first.n;
  }

  // Save version
  Future<void> saveVersion(int v) async {
    final prefs = await initInstance();
    const key = 'version';
    final value = v;
    prefs.setInt(key, value);
  }

  // Save book
  Future<void> saveBook(int b) async {
    final prefs = await initInstance();
    const key = 'book';
    final value = b;
    prefs.setInt(key, value);
  }

  // Save chapter
  Future<void> saveChapter(int c) async {
    final prefs = await initInstance();
    const key = 'chapter';
    final value = c;
    prefs.setInt(key, value);
  }

  Future<void> saveLang(String l) async {
    final prefs = await initInstance();
    const key = 'language';
    final value = l;
    prefs.setString(key, value);
  }

  Future<void> saveVerAbbr(String r) async {
    final prefs = await initInstance();
    const key = 'verabbr';
    final value = r;
    prefs.setString(key, value);
  }

  // Read version
  Future<int> readVersion() async {
    final prefs = await initInstance();
    const key = 'version';
    return prefs.getInt(key) ?? 1;
  }

  // Read book
  Future<int> readBook() async {
    final prefs = await initInstance();
    const key = 'book';
    return prefs.getInt(key) ?? 43; // Gospel of John
  }

  // Read chapter
  Future<int> readChapter() async {
    final prefs = await initInstance();
    const key = 'chapter';
    return prefs.getInt(key) ?? 1; // Chapter one
  }

  Future<String> readLang() async {
    final prefs = await initInstance();
    const key = 'language';
    return prefs.getString(key) ?? 'eng'; // English
  }

  Future<String> readVerAbbr() async {
    final prefs = await initInstance();
    const key = 'verabbr';
    return prefs.getString(key) ?? 'KJV'; // King James version
  }

  Future<String> readBookName() async {
    int b = await readBook();
    String l = await readLang();
    return await getLanguageBookName(b, l);
  }

  // Read version data
  // Future<String> readVersionData() async {
  //   int v = await readVersion();
  //   int b = await readBook();
  //   int c = await readChapter();
  //   return "$v|$b|$c";
  // }
}
