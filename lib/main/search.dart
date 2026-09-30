part of 'page.dart';

class HandleSearchCode extends StatefulWidget {
  const HandleSearchCode({super.key});

  @override
  HandleSearchCodeState createState() => HandleSearchCodeState();
}

class HandleSearchCodeState extends State<HandleSearchCode> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Bible> _results = [];
  bool _searching = false;
  int _searchRequestId = 0;
  //late String bibleVersionName;

  String _selectedCategory = 'All';

  final Map<String, List<int>> _categories = {
    'All': List.generate(66, (i) => i + 1),
    'Old Testament': List.generate(39, (i) => i + 1),
    'New Testament': List.generate(27, (i) => i + 40),
    'Pentateuch': List.generate(5, (i) => i + 1),
    'Historical': List.generate(12, (i) => i + 6),
    'Poetical': List.generate(5, (i) => i + 18),
    'Major Prophets': List.generate(5, (i) => i + 23),
    'Minor Prophets': List.generate(12, (i) => i + 28),
    'Gospels': List.generate(4, (i) => i + 40),
    'Acts': List.generate(1, (i) => i + 44),
    'Pauline Letters': List.generate(13, (i) => i + 45),
    'General Letters': List.generate(8, (i) => i + 58),
    'Revelation': List.generate(1, (i) => i + 66),
  };

  @override
  void initState() {
    super.initState();
    getSearchQuery().then((query) {
      if (mounted && query.isNotEmpty) {
        setState(() {
          _searchQuery = query;
          _searchController.text = query;
        });
      }
    });
    fetchLastSearch().then((results) {
      if (mounted) {
        setState(() {
          _results = results;
        });
      }
    });
  }

  Future<List<Bible>> fetchLastSearch() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('lastSearchResults');
    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((item) {
        return Bible()
          ..id = item['id'] ?? Isar.autoIncrement
          ..version = item['version'] ?? ''
          ..book = item['book'] ?? 1
          ..chapter = item['chapter'] ?? 1
          ..verse = item['verse'] ?? 1
          ..text = item['text'] ?? '';
      }).toList();
    } catch (e) {
      debugPrint('Error fetching last search results: $e');
      return [];
    }
  }

  Future<void> saveSearchQuery(String query) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastSearchQuery', query);
  }

  Future<String> getSearchQuery() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastSearchQuery') ?? '';
  }

  Future<String> checkSearchQuery(String query) async {
    if (query.isEmpty) {
      return await getSearchQuery();
    }
    return query;
  }

  bool _isAsciiAlphaNum(String char) {
    final codeUnit = char.codeUnitAt(0);
    final isUpper = codeUnit >= 65 && codeUnit <= 90;
    final isLower = codeUnit >= 97 && codeUnit <= 122;
    final isDigit = codeUnit >= 48 && codeUnit <= 57;
    return isUpper || isLower || isDigit;
  }

  bool _isBoundaryBeforeIndex(String text, int index) {
    if (index == 0) return true;

    final prevIndex = index - 1;
    final prevChar = text[prevIndex];

    // Normal letters/digits continue the same word.
    if (_isAsciiAlphaNum(prevChar)) {
      return false;
    }

    // Apostrophes and hyphens inside a token are treated as joiners.
    if ((prevChar == "'" || prevChar == '-') &&
        prevIndex > 0 &&
        _isAsciiAlphaNum(text[prevIndex - 1]) &&
        _isAsciiAlphaNum(text[index])) {
      return false;
    }

    return true;
  }

  bool _hasWordPrefixMatch(String text, String query) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int startIndex = 0;
    while (true) {
      final matchIndex = lowerText.indexOf(lowerQuery, startIndex);
      if (matchIndex == -1) return false;

      if (_isBoundaryBeforeIndex(lowerText, matchIndex)) {
        return true;
      }

      startIndex = matchIndex + 1;
    }
  }

  Future<void> _performSearch() async {
    final originalQuery = _searchController.text.trim();
    final requestId = ++_searchRequestId;

    if (originalQuery.isEmpty) {
      if (!mounted || requestId != _searchRequestId) return;
      setState(() {
        _searchQuery = '';
        _results = [];
        _searching = false;
      });
      return;
    }

    // save search query to history
    saveSearchQuery(originalQuery);

    setState(() {
      _searching = true;
      _results = [];
    });

    final version = Globals.bibleVersionName;
    final bookIds = _categories[_selectedCategory] ?? _categories['All']!;
    List<Bible> results = [];

    try {
      final candidateResults = await isar.bibles
          .filter()
          .versionEqualTo(version)
          .anyOf(bookIds, (q, int id) => q.bookEqualTo(id))
          .and()
          .textContains(originalQuery, caseSensitive: false)
          .findAll();

      final filtered = candidateResults
          .where((verse) => _hasWordPrefixMatch(verse.text, originalQuery))
          .toList();

      results = filtered;

      final prefs = await SharedPreferences.getInstance();
      final jsonList = results
          .map(
            (verse) => {
              'id': verse.id,
              'version': verse.version,
              'book': verse.book,
              'chapter': verse.chapter,
              'verse': verse.verse,
              'text': verse.text,
            },
          )
          .toList();
      await prefs.setString('lastSearchResults', jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Search error: $e');
    }

    if (mounted && requestId == _searchRequestId) {
      setState(() {
        _results = results;
        _searchQuery = originalQuery;
        _searching = false;
      });
    }
  }

  void _clearSearchResults() async {
    saveSearchQuery('');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('lastSearchResults');
    _searchController.clear();
    setState(() {
      _searchQuery = '';
      _results = [];
    });
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final mq = MediaQuery.of(context);
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        const tileContentPadding = EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        );
        const leadingSize = 50.0;
        final cats = _categories.keys.toList();

        return SafeArea(
          top: false,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            constraints: BoxConstraints(maxHeight: mq.size.height * 0.8),
            decoration: BoxDecoration(
              color: theme.canvasColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _BottomSheetDragHandle(),
                    const SizedBox(height: 8),
                    ...cats.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.5,
                                ),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: tileContentPadding,
                              leading: Container(
                                width: leadingSize,
                                height: leadingSize,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colorScheme.primaryContainer
                                      : colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    cat.isNotEmpty ? cat[0].toUpperCase() : '?',
                                    style: TextStyle(
                                      color: isSelected
                                        ? colorScheme.onPrimaryContainer
                                        : colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(cat),
                              subtitle: Text(
                                '${_categories[cat]?.length ?? 0} books',
                              ),
                              selected: isSelected,
                              trailing: isSelected
                                  ? Icon(Icons.check, color: theme.primaryColor)
                                  : null,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = cat;
                                });
                                Navigator.pop(context);
                                if (_searchController.text.isNotEmpty) {
                                  _performSearch();
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _highlightText(String text, String query, BuildContext context) {
    return FutureBuilder<String>(
      future: checkSearchQuery(query),
      builder: (context, snapshot) {
        final String resolvedQuery = snapshot.data ?? query;
        return _buildHighlightedRichText(text, resolvedQuery, context);
      },
    );
  }

  RichText _buildHighlightedRichText(
    String text,
    String query,
    BuildContext context,
  ) {
    if (query.isEmpty) {
      return RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      );
    }

    final List<TextSpan> spans = [];
    final String lowercaseText = text.toLowerCase();
    final String lowercaseQuery = query.toLowerCase();

    int start = 0;
    int indexOfHighlight;

    while ((indexOfHighlight = lowercaseText.indexOf(lowercaseQuery, start)) !=
        -1) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(text: text.substring(start, indexOfHighlight)));
      }

      spans.add(
        TextSpan(
          text: text.substring(
            indexOfHighlight,
            indexOfHighlight + query.length,
          ),
          style: TextStyle(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      );

      start = indexOfHighlight + query.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 16,
        ),
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);
    return SafeArea(
      top: false,
      child: Material(
        color: Theme.of(context).canvasColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: mq.size.height * 0.8),
          child: Padding(
            padding: EdgeInsets.all(
              HandleMainSelectorCodeState.gridMarginSpacing,
            ),
            child: Column(
              children: [
                const _BottomSheetDragHandle(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete_sweep, color: colorScheme.primary),
                        onPressed: _clearSearchResults,
                        tooltip: 'Clear Search',
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.category,
                          color: colorScheme.primary,
                        ),
                        onPressed: _showCategorySelector,
                        tooltip: 'Select Category',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                          16.0,
                          12.0,
                          16.0,
                          8.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search...',
                                  prefixIcon: const Icon(Icons.search),
                                  filled: true,
                                  fillColor: colorScheme.surface.withValues(
                                    alpha: 0.04,
                                  ),
                                  // outline border + focused/disabled variants
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: colorScheme.outline,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: colorScheme.outline,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide(
                                      color: colorScheme.primary,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                  ),
                                ),
                                onSubmitted: (_) => _performSearch(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Category: $_selectedCategory',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _searching
                            ? const Center(child: CircularProgressIndicator())
                            : _results.isEmpty && _searchQuery.isNotEmpty
                            ? const Center(child: Text('No results found.'))
                            : ListView.separated(
                                itemCount: _results.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (context, index) {
                                  final bible = _results[index];
                                  final bookName =
                                      BibleBooks.getBookNameByNumber(
                                        bible.book,
                                      );
                                  return ListTile(
                                    title: Text(
                                      '$bookName ${bible.chapter}:${bible.verse}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: _highlightText(
                                      bible.text,
                                      _searchQuery,
                                      context,
                                    ),
                                    onTap: () {
                                      // Navigate to the specific verse
                                      Globals.bibleBookNumber = bible.book;
                                      Globals.bibleChapterNumber =
                                          bible.chapter;
                                      Globals.bibleVerseNumber = bible.verse;

                                      Navigator.pop(context, true);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
