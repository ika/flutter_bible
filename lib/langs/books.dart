import 'package:bible/globals.dart';

class BibleBooks {
  static const Map<int, Map<String, String>> romanLatinNumerals = {
    1: {'roman': 'I', 'latin': 'unus'},
    2: {'roman': 'II', 'latin': 'duo'},
    3: {'roman': 'III', 'latin': 'tres'},
    4: {'roman': 'IV', 'latin': 'quattuor'},
    5: {'roman': 'V', 'latin': 'quinque'},
    6: {'roman': 'VI', 'latin': 'sex'},
    7: {'roman': 'VII', 'latin': 'septem'},
    8: {'roman': 'VIII', 'latin': 'octo'},
    9: {'roman': 'IX', 'latin': 'novem'},
    10: {'roman': 'X', 'latin': 'decem'},
    11: {'roman': 'XI', 'latin': 'undecim'},
    12: {'roman': 'XII', 'latin': 'duodecim'},
    13: {'roman': 'XIII', 'latin': 'tredecim'},
    14: {'roman': 'XIV', 'latin': 'quattuordecim'},
    15: {'roman': 'XV', 'latin': 'quindecim'},
    16: {'roman': 'XVI', 'latin': 'sedecim'},
    17: {'roman': 'XVII', 'latin': 'septendecim'},
    18: {'roman': 'XVIII', 'latin': 'duodeviginti'},
    19: {'roman': 'XIX', 'latin': 'undeviginti'},
    20: {'roman': 'XX', 'latin': 'viginti'},
    21: {'roman': 'XXI', 'latin': 'viginti unus'},
    22: {'roman': 'XXII', 'latin': 'viginti duo'},
    23: {'roman': 'XXIII', 'latin': 'viginti tres'},
    24: {'roman': 'XXIV', 'latin': 'viginti quattuor'},
    25: {'roman': 'XXV', 'latin': 'viginti quinque'},
    26: {'roman': 'XXVI', 'latin': 'viginti sex'},
    27: {'roman': 'XXVII', 'latin': 'viginti septem'},
    28: {'roman': 'XXVIII', 'latin': 'viginti octo'},
    29: {'roman': 'XXIX', 'latin': 'viginti novem'},
    30: {'roman': 'XXX', 'latin': 'triginta'},
    31: {'roman': 'XXXI', 'latin': 'triginta unus'},
    32: {'roman': 'XXXII', 'latin': 'triginta duo'},
    33: {'roman': 'XXXIII', 'latin': 'triginta tres'},
    34: {'roman': 'XXXIV', 'latin': 'triginta quattuor'},
    35: {'roman': 'XXXV', 'latin': 'triginta quinque'},
    36: {'roman': 'XXXVI', 'latin': 'triginta sex'},
    37: {'roman': 'XXXVII', 'latin': 'triginta septem'},
    38: {'roman': 'XXXVIII', 'latin': 'triginta octo'},
    39: {'roman': 'XXXIX', 'latin': 'triginta novem'},
    40: {'roman': 'XL', 'latin': 'quadraginta'},
    41: {'roman': 'XLI', 'latin': 'quadraginta unus'},
    42: {'roman': 'XLII', 'latin': 'quadraginta duo'},
    43: {'roman': 'XLIII', 'latin': 'quadraginta tres'},
    44: {'roman': 'XLIV', 'latin': 'quadraginta quattuor'},
    45: {'roman': 'XLV', 'latin': 'quadraginta quinque'},
    46: {'roman': 'XLVI', 'latin': 'quadraginta sex'},
    47: {'roman': 'XLVII', 'latin': 'quadraginta septem'},
    48: {'roman': 'XLVIII', 'latin': 'quadraginta octo'},
    49: {'roman': 'XLIX', 'latin': 'quadraginta novem'},
    50: {'roman': 'L', 'latin': 'quinquaginta'},
    51: {'roman': 'LI', 'latin': 'quinquaginta unus'},
    52: {'roman': 'LII', 'latin': 'quinquaginta duo'},
    53: {'roman': 'LIII', 'latin': 'quinquaginta tres'},
    54: {'roman': 'LIV', 'latin': 'quinquaginta quattuor'},
    55: {'roman': 'LV', 'latin': 'quinquaginta quinque'},
    56: {'roman': 'LVI', 'latin': 'quinquaginta sex'},
    57: {'roman': 'LVII', 'latin': 'quinquaginta septem'},
    58: {'roman': 'LVIII', 'latin': 'quinquaginta octo'},
    59: {'roman': 'LIX', 'latin': 'quinquaginta novem'},
    60: {'roman': 'LX', 'latin': 'sexaginta'},
    61: {'roman': 'LXI', 'latin': 'sexaginta unus'},
    62: {'roman': 'LXII', 'latin': 'sexaginta duo'},
    63: {'roman': 'LXIII', 'latin': 'sexaginta tres'},
    64: {'roman': 'LXIV', 'latin': 'sexaginta quattuor'},
    65: {'roman': 'LXV', 'latin': 'sexaginta quinque'},
    66: {'roman': 'LXVI', 'latin': 'sexaginta sex'},
    67: {'roman': 'LXVII', 'latin': 'sexaginta septem'},
    68: {'roman': 'LXVIII', 'latin': 'sexaginta octo'},
    69: {'roman': 'LXIX', 'latin': 'sexaginta novem'},
    70: {'roman': 'LXX', 'latin': 'septuaginta'},
    71: {'roman': 'LXXI', 'latin': 'septuaginta unus'},
    72: {'roman': 'LXXII', 'latin': 'septuaginta duo'},
    73: {'roman': 'LXXIII', 'latin': 'septuaginta tres'},
    74: {'roman': 'LXXIV', 'latin': 'septuaginta quattuor'},
    75: {'roman': 'LXXV', 'latin': 'septuaginta quinque'},
    76: {'roman': 'LXXVI', 'latin': 'septuaginta sex'},
    77: {'roman': 'LXXVII', 'latin': 'septuaginta septem'},
    78: {'roman': 'LXXVIII', 'latin': 'septuaginta octo'},
    79: {'roman': 'LXXIX', 'latin': 'septuaginta novem'},
    80: {'roman': 'LXXX', 'latin': 'octoginta'},
    81: {'roman': 'LXXXI', 'latin': 'octoginta unus'},
    82: {'roman': 'LXXXII', 'latin': 'octoginta duo'},
    83: {'roman': 'LXXXIII', 'latin': 'octoginta tres'},
    84: {'roman': 'LXXXIV', 'latin': 'octoginta quattuor'},
    85: {'roman': 'LXXXV', 'latin': 'octoginta quinque'},
    86: {'roman': 'LXXXVI', 'latin': 'octoginta sex'},
    87: {'roman': 'LXXXVII', 'latin': 'octoginta septem'},
    88: {'roman': 'LXXXVIII', 'latin': 'octoginta octo'},
    89: {'roman': 'LXXXIX', 'latin': 'octoginta novem'},
    90: {'roman': 'XC', 'latin': 'nonaginta'},
    91: {'roman': 'XCI', 'latin': 'nonaginta unus'},
    92: {'roman': 'XCII', 'latin': 'nonaginta duo'},
    93: {'roman': 'XCIII', 'latin': 'nonaginta tres'},
    94: {'roman': 'XCIV', 'latin': 'nonaginta quattuor'},
    95: {'roman': 'XCV', 'latin': 'nonaginta quinque'},
    96: {'roman': 'XCVI', 'latin': 'nonaginta sex'},
    97: {'roman': 'XCVII', 'latin': 'nonaginta septem'},
    98: {'roman': 'XCVIII', 'latin': 'nonaginta octo'},
    99: {'roman': 'XCIX', 'latin': 'nonaginta novem'},
    100: {'roman': 'C', 'latin': 'centum'},
    101: {'roman': 'CI', 'latin': 'centum unus'},
    102: {'roman': 'CII', 'latin': 'centum duo'},
    103: {'roman': 'CIII', 'latin': 'centum tres'},
    104: {'roman': 'CIV', 'latin': 'centum quattuor'},
    105: {'roman': 'CV', 'latin': 'centum quinque'},
    106: {'roman': 'CVI', 'latin': 'centum sex'},
    107: {'roman': 'CVII', 'latin': 'centum septem'},
    108: {'roman': 'CVIII', 'latin': 'centum octo'},
    109: {'roman': 'CIX', 'latin': 'centum novem'},
    110: {'roman': 'CX', 'latin': 'centum decem'},
    111: {'roman': 'CXI', 'latin': 'centum undecim'},
    112: {'roman': 'CXII', 'latin': 'centum duodecim'},
    113: {'roman': 'CXIII', 'latin': 'centum tredecim'},
    114: {'roman': 'CXIV', 'latin': 'centum quattuordecim'},
    115: {'roman': 'CXV', 'latin': 'centum quindecim'},
    116: {'roman': 'CXVI', 'latin': 'centum sedecim'},
    117: {'roman': 'CXVII', 'latin': 'centum septendecim'},
    118: {'roman': 'CXVIII', 'latin': 'centum duodeviginti'},
    119: {'roman': 'CXIX', 'latin': 'centum undeviginti'},
    120: {'roman': 'CXX', 'latin': 'centum viginti'},
    121: {'roman': 'CXXI', 'latin': 'centum viginti unus'},
    122: {'roman': 'CXXII', 'latin': 'centum viginti duo'},
    123: {'roman': 'CXXIII', 'latin': 'centum viginti tres'},
    124: {'roman': 'CXXIV', 'latin': 'centum viginti quattuor'},
    125: {'roman': 'CXXV', 'latin': 'centum viginti quinque'},
    126: {'roman': 'CXXVI', 'latin': 'centum viginti sex'},
    127: {'roman': 'CXXVII', 'latin': 'centum viginti septem'},
    128: {'roman': 'CXXVIII', 'latin': 'centum viginti octo'},
    129: {'roman': 'CXXIX', 'latin': 'centum viginti novem'},
    130: {'roman': 'CXXX', 'latin': 'centum triginta'},
    131: {'roman': 'CXXXI', 'latin': 'centum triginta unus'},
    132: {'roman': 'CXXXII', 'latin': 'centum triginta duo'},
    133: {'roman': 'CXXXIII', 'latin': 'centum triginta tres'},
    134: {'roman': 'CXXXIV', 'latin': 'centum triginta quattuor'},
    135: {'roman': 'CXXXV', 'latin': 'centum triginta quinque'},
    136: {'roman': 'CXXXVI', 'latin': 'centum triginta sex'},
    137: {'roman': 'CXXXVII', 'latin': 'centum triginta septem'},
    138: {'roman': 'CXXXVIII', 'latin': 'centum triginta octo'},
    139: {'roman': 'CXXXIX', 'latin': 'centum triginta novem'},
    140: {'roman': 'CXL', 'latin': 'centum quadraginta'},
    141: {'roman': 'CXLI', 'latin': 'centum quadraginta unus'},
    142: {'roman': 'CXLII', 'latin': 'centum quadraginta duo'},
    143: {'roman': 'CXLIII', 'latin': 'centum quadraginta tres'},
    144: {'roman': 'CXLIV', 'latin': 'centum quadraginta quattuor'},
    145: {'roman': 'CXLV', 'latin': 'centum quadraginta quinque'},
    146: {'roman': 'CXLVI', 'latin': 'centum quadraginta sex'},
    147: {'roman': 'CXLVII', 'latin': 'centum quadraginta septem'},
    148: {'roman': 'CXLVIII', 'latin': 'centum quadraginta octo'},
    149: {'roman': 'CXLIX', 'latin': 'centum quadraginta novem'},
    150: {'roman': 'CL', 'latin': 'centum quinquaginta'},
    151: {'roman': 'CLI', 'latin': 'centum quinquaginta unus'},
    152: {'roman': 'CLII', 'latin': 'centum quinquaginta duo'},
    153: {'roman': 'CLIII', 'latin': 'centum quinquaginta tres'},
    154: {'roman': 'CLIV', 'latin': 'centum quinquaginta quattuor'},
    155: {'roman': 'CLV', 'latin': 'centum quinquaginta quinque'},
    156: {'roman': 'CLVI', 'latin': 'centum quinquaginta sex'},
    157: {'roman': 'CLVII', 'latin': 'centum quinquaginta septem'},
    158: {'roman': 'CLVIII', 'latin': 'centum quinquaginta octo'},
    159: {'roman': 'CLIX', 'latin': 'centum quinquaginta novem'},
    160: {'roman': 'CLX', 'latin': 'centum sexaginta'},
    161: {'roman': 'CLXI', 'latin': 'centum sexaginta unus'},
    162: {'roman': 'CLXII', 'latin': 'centum sexaginta duo'},
    163: {'roman': 'CLXIII', 'latin': 'centum sexaginta tres'},
    164: {'roman': 'CLXIV', 'latin': 'centum sexaginta quattuor'},
    165: {'roman': 'CLXV', 'latin': 'centum sexaginta quinque'},
    166: {'roman': 'CLXVI', 'latin': 'centum sexaginta sex'},
    167: {'roman': 'CLXVII', 'latin': 'centum sexaginta septem'},
    168: {'roman': 'CLXVIII', 'latin': 'centum sexaginta octo'},
    169: {'roman': 'CLXIX', 'latin': 'centum sexaginta novem'},
    170: {'roman': 'CLXX', 'latin': 'centum septuaginta'},
    171: {'roman': 'CLXXI', 'latin': 'centum septuaginta unus'},
    172: {'roman': 'CLXXII', 'latin': 'centum septuaginta duo'},
    173: {'roman': 'CLXXIII', 'latin': 'centum septuaginta tres'},
    174: {'roman': 'CLXXIV', 'latin': 'centum septuaginta quattuor'},
    175: {'roman': 'CLXXV', 'latin': 'centum septuaginta quinque'},
    176: {'roman': 'CLXXVI', 'latin': 'centum septuaginta sex'},
    177: {'roman': 'CLXXVII', 'latin': 'centum septuaginta septem'},
    178: {'roman': 'CLXXVIII', 'latin': 'centum septuaginta octo'},
    179: {'roman': 'CLXXIX', 'latin': 'centum septuaginta novem'},
    180: {'roman': 'CLXXX', 'latin': 'centum octoginta'},
    181: {'roman': 'CLXXXI', 'latin': 'centum octoginta unus'},
    182: {'roman': 'CLXXXII', 'latin': 'centum octoginta duo'},
    183: {'roman': 'CLXXXIII', 'latin': 'centum octoginta tres'},
    184: {'roman': 'CLXXXIV', 'latin': 'centum octoginta quattuor'},
    185: {'roman': 'CLXXXV', 'latin': 'centum octoginta quinque'},
    186: {'roman': 'CLXXXVI', 'latin': 'centum octoginta sex'},
    187: {'roman': 'CLXXXVII', 'latin': 'centum octoginta septem'},
    188: {'roman': 'CLXXXVIII', 'latin': 'centum octoginta octo'},
    189: {'roman': 'CLXXXIX', 'latin': 'centum octoginta novem'},
    190: {'roman': 'CXC', 'latin': 'centum nonaginta'},
    191: {'roman': 'CXCI', 'latin': 'centum nonaginta unus'},
    192: {'roman': 'CXCII', 'latin': 'centum nonaginta duo'},
    193: {'roman': 'CXCIII', 'latin': 'centum nonaginta tres'},
    194: {'roman': 'CXCIV', 'latin': 'centum nonaginta quattuor'},
    195: {'roman': 'CXCV', 'latin': 'centum nonaginta quinque'},
    196: {'roman': 'CXCVI', 'latin': 'centum nonaginta sex'},
    197: {'roman': 'CXCVII', 'latin': 'centum nonaginta septem'},
    198: {'roman': 'CXCVIII', 'latin': 'centum nonaginta octo'},
    199: {'roman': 'CXCIX', 'latin': 'centum nonaginta novem'},
    200: {'roman': 'CC', 'latin': 'ducenti'},
  };

  // Forward mapping: abbreviation → number (Protestant 1-66)

  // Reverse mapping: number → abbreviation + full name
  static const Map<int, Map<String, String>> reverseBookMappings = {
    1: {'abbr': 'GEN', 'name': 'Genesis'},
    2: {'abbr': 'EXO', 'name': 'Exodus'},
    3: {'abbr': 'LEV', 'name': 'Leviticus'},
    4: {'abbr': 'NUM', 'name': 'Numbers'},
    5: {'abbr': 'DEU', 'name': 'Deuteronomy'},
    6: {'abbr': 'JOS', 'name': 'Joshua'},
    7: {'abbr': 'JDG', 'name': 'Judges'},
    8: {'abbr': 'RUT', 'name': 'Ruth'},
    9: {'abbr': '1SA', 'name': '1 Samuel'},
    10: {'abbr': '2SA', 'name': '2 Samuel'},
    11: {'abbr': '1KI', 'name': '1 Kings'},
    12: {'abbr': '2KI', 'name': '2 Kings'},
    13: {'abbr': '1CH', 'name': '1 Chronicles'},
    14: {'abbr': '2CH', 'name': '2 Chronicles'},
    15: {'abbr': 'EZR', 'name': 'Ezra'},
    16: {'abbr': 'NEH', 'name': 'Nehemiah'},
    17: {'abbr': 'EST', 'name': 'Esther'},
    18: {'abbr': 'JOB', 'name': 'Job'},
    19: {'abbr': 'PSA', 'name': 'Psalms'},
    20: {'abbr': 'PRO', 'name': 'Proverbs'},
    21: {'abbr': 'ECC', 'name': 'Ecclesiastes'},
    22: {'abbr': 'SNG', 'name': 'Song of Songs'},
    23: {'abbr': 'ISA', 'name': 'Isaiah'},
    24: {'abbr': 'JER', 'name': 'Jeremiah'},
    25: {'abbr': 'LAM', 'name': 'Lamentations'},
    26: {'abbr': 'EZK', 'name': 'Ezekiel'},
    27: {'abbr': 'DAN', 'name': 'Daniel'},
    28: {'abbr': 'HOS', 'name': 'Hosea'},
    29: {'abbr': 'JOL', 'name': 'Joel'},
    30: {'abbr': 'AMO', 'name': 'Amos'},
    31: {'abbr': 'OBA', 'name': 'Obadiah'},
    32: {'abbr': 'JON', 'name': 'Jonah'},
    33: {'abbr': 'MIC', 'name': 'Micah'},
    34: {'abbr': 'NAM', 'name': 'Nahum'},
    35: {'abbr': 'HAB', 'name': 'Habakkuk'},
    36: {'abbr': 'ZEP', 'name': 'Zephaniah'},
    37: {'abbr': 'HAG', 'name': 'Haggai'},
    38: {'abbr': 'ZEC', 'name': 'Zechariah'},
    39: {'abbr': 'MAL', 'name': 'Malachi'},
    40: {'abbr': 'MAT', 'name': 'Matthew'},
    41: {'abbr': 'MRK', 'name': 'Mark'},
    42: {'abbr': 'LUK', 'name': 'Luke'},
    43: {'abbr': 'JHN', 'name': 'John'},
    44: {'abbr': 'ACT', 'name': 'Acts'},
    45: {'abbr': 'ROM', 'name': 'Romans'},
    46: {'abbr': '1CO', 'name': '1 Corinthians'},
    47: {'abbr': '2CO', 'name': '2 Corinthians'},
    48: {'abbr': 'GAL', 'name': 'Galatians'},
    49: {'abbr': 'EPH', 'name': 'Ephesians'},
    50: {'abbr': 'PHP', 'name': 'Philippians'},
    51: {'abbr': 'COL', 'name': 'Colossians'},
    52: {'abbr': '1TH', 'name': '1 Thessalonians'},
    53: {'abbr': '2TH', 'name': '2 Thessalonians'},
    54: {'abbr': '1TI', 'name': '1 Timothy'},
    55: {'abbr': '2TI', 'name': '2 Timothy'},
    56: {'abbr': 'TIT', 'name': 'Titus'},
    57: {'abbr': 'PHM', 'name': 'Philemon'},
    58: {'abbr': 'HEB', 'name': 'Hebrews'},
    59: {'abbr': 'JAS', 'name': 'James'},
    60: {'abbr': '1PE', 'name': '1 Peter'},
    61: {'abbr': '2PE', 'name': '2 Peter'},
    62: {'abbr': '1JN', 'name': '1 John'},
    63: {'abbr': '2JN', 'name': '2 John'},
    64: {'abbr': '3JN', 'name': '3 John'},
    65: {'abbr': 'JUD', 'name': 'Jude'},
    66: {'abbr': 'REV', 'name': 'Revelation'},
  };

  static const Map<int, Map<String, String>> reverseBookMappingsLatin = {
    1: {'abbr': 'GEN', 'name': 'Genesis'},
    2: {'abbr': 'EXD', 'name': 'Exodus'},
    3: {'abbr': 'LEV', 'name': 'Leviticus'},
    4: {'abbr': 'NUM', 'name': 'Numeri'},
    5: {'abbr': 'DEU', 'name': 'Deuteronomium'},
    6: {'abbr': 'IOS', 'name': 'Iosue'},
    7: {'abbr': 'IUD', 'name': 'Iudices'},
    8: {'abbr': 'RUT', 'name': 'Ruth'},
    9: {'abbr': '1SM', 'name': '1 Samuelis'},
    10: {'abbr': '2SM', 'name': '2 Samuelis'},
    11: {'abbr': '1RG', 'name': '1 Regum'},
    12: {'abbr': '2RG', 'name': '2 Regum'},
    13: {'abbr': '1PR', 'name': '1 Paralipomenon'},
    14: {'abbr': '2PR', 'name': '2 Paralipomenon'},
    15: {'abbr': 'ESD', 'name': 'Esdrae'},
    16: {'abbr': 'NEH', 'name': 'Nehemiae'},
    17: {'abbr': 'EST', 'name': 'Esther'},
    18: {'abbr': 'IOB', 'name': 'Iob'},
    19: {'abbr': 'PSA', 'name': 'Psalmi'},
    20: {'abbr': 'PRV', 'name': 'Proverbia'},
    21: {'abbr': 'ECC', 'name': 'Ecclesiastes'},
    22: {'abbr': 'CNT', 'name': 'Canticum Canticorum'},
    23: {'abbr': 'ISA', 'name': 'Isaias'},
    24: {'abbr': 'IER', 'name': 'Ieremias'},
    25: {'abbr': 'LAM', 'name': 'Lamentationes'},
    26: {'abbr': 'EZE', 'name': 'Ezechiel'},
    27: {'abbr': 'DAN', 'name': 'Daniel'},
    28: {'abbr': 'OSE', 'name': 'Osee'},
    29: {'abbr': 'IOE', 'name': 'Ioel'},
    30: {'abbr': 'AMO', 'name': 'Amos'},
    31: {'abbr': 'ABD', 'name': 'Abdias'},
    32: {'abbr': 'ION', 'name': 'Ionas'},
    33: {'abbr': 'MIC', 'name': 'Michaea'},
    34: {'abbr': 'NAH', 'name': 'Nahum'},
    35: {'abbr': 'HAB', 'name': 'Habacuc'},
    36: {'abbr': 'SOP', 'name': 'Sophonias'},
    37: {'abbr': 'AGG', 'name': 'Aggaeus'},
    38: {'abbr': 'ZAC', 'name': 'Zacharias'},
    39: {'abbr': 'MAL', 'name': 'Malachias'},
    40: {'abbr': 'MAT', 'name': 'Matthaeus'},
    41: {'abbr': 'MAR', 'name': 'Marcus'},
    42: {'abbr': 'LUC', 'name': 'Lucas'},
    43: {'abbr': 'IOA', 'name': 'Ioannes'},
    44: {'abbr': 'ACT', 'name': 'Actus Apostolorum'},
    45: {'abbr': 'ROM', 'name': 'Ad Romanos'},
    46: {'abbr': '1CO', 'name': '1 Ad Corinthios'},
    47: {'abbr': '2CO', 'name': '2 Ad Corinthios'},
    48: {'abbr': 'GAL', 'name': 'Ad Galatas'},
    49: {'abbr': 'EPH', 'name': 'Ad Ephesios'},
    50: {'abbr': 'PHP', 'name': 'Ad Philippenses'},
    51: {'abbr': 'COL', 'name': 'Ad Colossenses'},
    52: {'abbr': '1TH', 'name': '1 Ad Thessalonicenses'},
    53: {'abbr': '2TH', 'name': '2 Ad Thessalonicenses'},
    54: {'abbr': '1TM', 'name': '1 Ad Timotheum'},
    55: {'abbr': '2TM', 'name': '2 Ad Timotheum'},
    56: {'abbr': 'TIT', 'name': 'Ad Titum'},
    57: {'abbr': 'PHM', 'name': 'Ad Philemonem'},
    58: {'abbr': 'HEB', 'name': 'Ad Hebraeos'},
    59: {'abbr': 'IAC', 'name': 'Iacobus'},
    60: {'abbr': '1PT', 'name': '1 Petri'},
    61: {'abbr': '2PT', 'name': '2 Petri'},
    62: {'abbr': '1IO', 'name': '1 Ioannis'},
    63: {'abbr': '2IO', 'name': '2 Ioannis'},
    64: {'abbr': '3IO', 'name': '3 Ioannis'},
    65: {'abbr': 'IDA', 'name': 'Iudas'},
    66: {'abbr': 'APC', 'name': 'Apocalypsis'},
  };

  static final List<int> allBooks = List.generate(66, (i) => i + 1);
  static final List<int> oldTestament = List.generate(39, (i) => i + 1);
  static final List<int> newTestament = List.generate(27, (i) => i + 40);

  static Map<int, String> getAllBookNames() {
    switch (Globals.bibleVersionLanguage) {
      case 'lat':
        return {
          for (var n in allBooks) n: reverseBookMappingsLatin[n]!['name']!,
        };
      default:
        return {for (var n in allBooks) n: reverseBookMappings[n]!['name']!};
    }
  }

  static Map<int, String> getOldTestamentNames() {
    switch (Globals.bibleVersionLanguage) {
      case 'lat':
        return {
          for (var n in oldTestament) n: reverseBookMappingsLatin[n]!['name']!,
        };
      default:
        return {
          for (var n in oldTestament) n: reverseBookMappings[n]!['name']!,
        };
    }
  }

  static Map<int, String> getNewTestamentNames() {
    switch (Globals.bibleVersionLanguage) {
      case 'lat':
        return {
          for (var n in newTestament) n: reverseBookMappingsLatin[n]!['name']!,
        };
      default:
        return {
          for (var n in newTestament) n: reverseBookMappings[n]!['name']!,
        };
    }
  }

  static String getBookAbbrByNumber(int n) {
    switch (Globals.bibleVersionLanguage) {
      case 'lat':
        return reverseBookMappingsLatin[n]?['abbr'] ?? 'Unknown Abbr';
      default:
        return reverseBookMappings[n]?['abbr'] ?? 'Unknown Abbr';
    }
  }

  static String getBookNameByNumber(int n) {
    switch (Globals.bibleVersionLanguage) {
      case 'lat':
        return reverseBookMappingsLatin[n]?['name'] ?? 'Unknown Book';
      default:
        return reverseBookMappings[n]?['name'] ?? 'Unknown Book';
    }
  }

  static String formatNumberInLanguage(int number) {
    if (Globals.bibleVersionLanguage == 'lat') {
      return romanLatinNumerals[number]?['roman'] ?? number.toString();
    }
    return number.toString();
  }

  static String formatNameInLanguage(int number) {
    if (Globals.bibleVersionLanguage == 'lat') {
      return romanLatinNumerals[number]?['latin'] ?? number.toString();
    }
    return number.toString();
  }

  static Map<int, String> searchBooks(String query) {
    if (query.isEmpty) {
      return getAllBookNames();
    }

    final lowercaseQuery = query.toLowerCase();
    final allNames = getAllBookNames();

    // Returns a new map containing only entries where the name contains the query
    return Map.fromEntries(
      allNames.entries.where(
        (entry) => entry.value.toLowerCase().contains(lowercaseQuery),
      ),
    );
  }
}
