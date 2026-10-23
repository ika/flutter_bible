part of 'page.dart';

class HandleSearchCode extends StatefulWidget {
  const HandleSearchCode({super.key});

  @override
  HandleSearchCodeState createState() => HandleSearchCodeState();
}

class HandleSearchCodeState extends State<HandleSearchCode> {
  static const _lastQueryKey = 'lastSearchQuery';
  static const _lastResultsKey = 'lastSearchResults';

  static final Map<String, List<int>> _categories = {
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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<Bible> _results = [];
  bool _searching = false;
  int _searchRequestId = 0;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadSavedSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSearch() async {
    final prefs = await SharedPreferences.getInstance();
    final query = prefs.getString(_lastQueryKey) ?? '';
    final jsonString = prefs.getString(_lastResultsKey);

    List<Bible> results = [];
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        results = jsonList.map((item) {
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
      }
    }

    if (mounted) {
      setState(() {
        if (query.isNotEmpty) {
          _searchQuery = query;
          _searchController.text = query;
        }
        _results = results;
      });
    }
  }

  Future<void> _saveSearchResults(String query, List<Bible> results) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_lastQueryKey, query);
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
      await prefs.setString(_lastResultsKey, jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving search results: $e');
    }
  }

  Future<void> _clearSearchResults() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastQueryKey);
    await prefs.remove(_lastResultsKey);
    _searchController.clear();
    if (mounted) {
      setState(() {
        _searchQuery = '';
        _results = [];
      });
    }
  }

  static bool _isAsciiAlphaNum(String char) {
    final codeUnit = char.codeUnitAt(0);
    return (codeUnit >= 65 && codeUnit <= 90) ||
        (codeUnit >= 97 && codeUnit <= 122) ||
        (codeUnit >= 48 && codeUnit <= 57);
  }

  static bool _isBoundaryBeforeIndex(String text, int index) {
    if (index == 0) return true;

    final prevIndex = index - 1;
    final prevChar = text[prevIndex];

    if (_isAsciiAlphaNum(prevChar)) {
      return false;
    }

    if ((prevChar == "'" || prevChar == '-') &&
        prevIndex > 0 &&
        _isAsciiAlphaNum(text[prevIndex - 1]) &&
        _isAsciiAlphaNum(text[index])) {
      return false;
    }

    return true;
  }

  static bool _hasWordPrefixMatch(String text, String query) {
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

      results = candidateResults
          .where((verse) => _hasWordPrefixMatch(verse.text, originalQuery))
          .toList();

      await _saveSearchResults(originalQuery, results);
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

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        final theme = Theme.of(bottomSheetContext);
        final colorScheme = theme.colorScheme;
        final size = MediaQuery.sizeOf(bottomSheetContext);
        final bottomInset = MediaQuery.viewInsetsOf(bottomSheetContext).bottom;
        final cats = _categories.keys.toList();

        return SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(maxHeight: size.height * 0.8),
            decoration: BoxDecoration(
              color: theme.canvasColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset + 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _BottomSheetDragHandle(),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: cats.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final cat = cats[index];
                        final isSelected = _selectedCategory == cat;
                        return Card(
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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: Container(
                              width: 50,
                              height: 50,
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
                              Navigator.pop(bottomSheetContext);
                              if (_searchController.text.isNotEmpty) {
                                _performSearch();
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHighlightedText(
    String text,
    String query,
    ColorScheme colorScheme,
  ) {
    if (query.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
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
            backgroundColor: colorScheme.primaryContainer,
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
      );

      start = indexOfHighlight + query.length;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return Text.rich(
      TextSpan(
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16,
        ),
        children: spans,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    return SafeArea(
      top: false,
      child: Material(
        color: theme.canvasColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: size.height * 0.8),
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
                        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: colorScheme.surface.withValues(
                              alpha: 0.04,
                            ),
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
                                    subtitle: _buildHighlightedText(
                                      bible.text,
                                      _searchQuery,
                                      colorScheme,
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
