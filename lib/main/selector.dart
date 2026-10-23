part of 'page.dart';

enum _TestamentFilter { all, ot, nt }

class HandleMainSelectorCode extends StatefulWidget {
  const HandleMainSelectorCode({super.key});

  @override
  State<HandleMainSelectorCode> createState() => HandleMainSelectorCodeState();
}

class HandleMainSelectorCodeState extends State<HandleMainSelectorCode> {
  static const double gridMarginSpacing = 16.0;

  final TextEditingController _searchController = TextEditingController();
  _TestamentFilter _filter = _TestamentFilter.all;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Map<int, String> _getFilteredBooks() {
    Map<int, String> books;
    switch (_filter) {
      case _TestamentFilter.all:
        books = BibleBooks.getAllBookNames();
      case _TestamentFilter.ot:
        books = BibleBooks.getOldTestamentNames();
      case _TestamentFilter.nt:
        books = BibleBooks.getNewTestamentNames();
    }

    if (_searchQuery.trim().isEmpty) {
      return books;
    }

    final query = _searchQuery.trim().toLowerCase();
    return Map.fromEntries(
      books.entries.where((entry) {
        final name = entry.value.toLowerCase();
        final abbr = BibleBooks.getBookAbbrByNumber(entry.key).toLowerCase();
        return name.contains(query) || abbr.contains(query);
      }),
    );
  }

  Future<int> _fetchChapterCount({
    required String version,
    required int book,
  }) async {
    try {
      return await isar.bibles
          .filter()
          .versionEqualTo(version)
          .bookEqualTo(book)
          .distinctByChapter()
          .count();
    } catch (e) {
      debugPrint('Error fetching chapter count: $e');
      return 0;
    }
  }

  Future<int> _fetchVerseCount({
    required String version,
    required int book,
    required int chapter,
  }) async {
    try {
      return await isar.bibles
          .filter()
          .versionEqualTo(version)
          .bookEqualTo(book)
          .chapterEqualTo(chapter)
          .count();
    } catch (e) {
      debugPrint('Error fetching verse count: $e');
      return 0;
    }
  }

  Future<bool?> _showVersesPopup({
    required BuildContext context,
    required String bookName,
    required int bookNumber,
    required int chapterNumber,
    required int verseCount,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => _VerseGridSheet(
        bookName: bookName,
        bookNumber: bookNumber,
        chapterNumber: chapterNumber,
        verseCount: verseCount,
      ),
    );
  }

  Future<bool?> _showChaptersPopup({
    required BuildContext context,
    required String bookName,
    required int bookNumber,
    required int chapterCount,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) => _ChapterGridSheet(
        bookName: bookName,
        bookNumber: bookNumber,
        chapterCount: chapterCount,
        onChapterSelected: (chapterNum) async {
          final count = await _fetchVerseCount(
            version: Globals.bibleVersionName,
            book: bookNumber,
            chapter: chapterNum,
          );

          if (!bottomSheetContext.mounted) return false;

          final selected = await _showVersesPopup(
            context: bottomSheetContext,
            bookName: bookName,
            bookNumber: bookNumber,
            chapterNumber: chapterNum,
            verseCount: count,
          );

          return selected == true;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final filteredBooks = _getFilteredBooks();

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.85),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset + 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _BottomSheetDragHandle(),
              const SizedBox(height: 8),
              SegmentedButton<_TestamentFilter>(
                segments: const [
                  ButtonSegment(
                    value: _TestamentFilter.all,
                    label: Text('All'),
                  ),
                  ButtonSegment(
                    value: _TestamentFilter.ot,
                    label: Text('Old Testament'),
                  ),
                  ButtonSegment(
                    value: _TestamentFilter.nt,
                    label: Text('New Testament'),
                  ),
                ],
                selected: {_filter},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    _filter = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                autofocus: false,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search books...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        )
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filteredBooks.isEmpty
                    ? Center(
                        child: Text(
                          'No books found',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredBooks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final bookNumber =
                              filteredBooks.keys.elementAt(index);
                          final bookName = filteredBooks[bookNumber]!;
                          final isOT = bookNumber <= 39;

                          return Card(
                            elevation: 0,
                            margin: EdgeInsets.zero,
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
                                vertical: 4,
                              ),
                              leading: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    BibleBooks.getBookAbbrByNumber(bookNumber),
                                    style: TextStyle(
                                      color: colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                bookName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                isOT ? 'Old Testament' : 'New Testament',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              trailing: Icon(
                                Icons.chevron_right,
                                color: colorScheme.primary,
                              ),
                              onTap: () async {
                                final count = await _fetchChapterCount(
                                  version: Globals.bibleVersionName,
                                  book: bookNumber,
                                );

                                if (!context.mounted) return;

                                final selected = await _showChaptersPopup(
                                  context: context,
                                  bookName: bookName,
                                  bookNumber: bookNumber,
                                  chapterCount: count,
                                );

                                if (selected == true && context.mounted) {
                                  Navigator.pop(context, true);
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
  }
}

class _ChapterGridSheet extends StatelessWidget {
  const _ChapterGridSheet({
    required this.bookName,
    required this.bookNumber,
    required this.chapterCount,
    required this.onChapterSelected,
  });

  final String bookName;
  final int bookNumber;
  final int chapterCount;
  final Future<bool> Function(int chapterNum) onChapterSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.8),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _BottomSheetDragHandle(),
              const SizedBox(height: 4),
              Text(
                bookName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Select Chapter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: chapterCount <= 0
                    ? Center(
                        child: Text(
                          'No chapters found',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      )
                    : GridView.builder(
                        itemCount: chapterCount,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.1,
                        ),
                        itemBuilder: (context, index) {
                          final chapterNum = index + 1;
                          return Material(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () async {
                                final selected =
                                    await onChapterSelected(chapterNum);
                                if (selected && context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  BibleBooks.formatNumberInLanguage(
                                    chapterNum,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
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
  }
}

class _VerseGridSheet extends StatelessWidget {
  const _VerseGridSheet({
    required this.bookName,
    required this.bookNumber,
    required this.chapterNumber,
    required this.verseCount,
  });

  final String bookName;
  final int bookNumber;
  final int chapterNumber;
  final int verseCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.8),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _BottomSheetDragHandle(),
              const SizedBox(height: 4),
              Text(
                '$bookName ${BibleBooks.formatNumberInLanguage(chapterNumber)}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Select Verse',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: verseCount <= 0
                    ? Center(
                        child: Text(
                          'No verses found',
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      )
                    : GridView.builder(
                        itemCount: verseCount,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.1,
                        ),
                        itemBuilder: (context, index) {
                          final verseNum = index + 1;
                          return Material(
                            color: colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Globals.bibleBookName = bookName;
                                Globals.bibleBookNumber = bookNumber;
                                Globals.bibleChapterNumber = chapterNumber;
                                Globals.bibleVerseNumber = verseNum;
                                Navigator.pop(context, true);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: colorScheme.outlineVariant
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  BibleBooks.formatNumberInLanguage(verseNum),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
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
  }
}