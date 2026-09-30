//-------------------------------------------------------------
// Constants
//-------------------------------------------------------------

// Edit this value to point the app at a different bookmark API server.
//ignore: constant_identifier_names
//const String BOOKMARK_API_URL = 'http://localhost/api';
//ignore: constant_identifier_names
const String BOOKMARK_API_URL = 'http://129.151.180.146/api';

class Constants {
  static const Map<String, Map<String, String>> bibleVersionsMap = {
    'nvlg': {
      'name': 'New Vulgate',
      'lang': 'lat',
      'number': '1',
      'version': '1',
    },
    'cpdv': {
      'name': 'Catholic Public Domain',
      'lang': 'eng',
      'number': '2',
      'version': '1',
    },
    'clem': {
      'name': 'Clementine Vulgate',
      'lang': 'lat',
      'number': '3',
      'version': '1',
    },
    'esv': {
      'name': 'English Standard Version',
      'lang': 'eng',
      'number': '4',
      'version': '1',
    },
  };

  static const List<String> bibleLanguages = ['eng', 'lat'];

  static const String isarDatabaseName = "flutter_bible_data";
}
