part of 'page.dart';

class CompareVersesSheet extends StatelessWidget {
  const CompareVersesSheet({super.key, required this.bibleModel});

  final Bible bibleModel;

  Future<List<_CompareVerseItem>> _loadParallelData() async {
    try {
      // 1. Get the current active version
      final currentVersion = Globals.bibleVersionName.toLowerCase();

      // 2. Get active versions from bookLists collection, excluding the current one
      final activeBooks = await isar.bookLists
          .filter()
          .activeEqualTo(true)
          .sortByNumber()
          .findAll();

      final compareBooks = activeBooks
          .where((book) => book.abbr.toLowerCase() != currentVersion)
          .toList();

      if (compareBooks.isEmpty) return [];

      final candidateAbbrs = compareBooks.map((b) => b.abbr).toList();

      // 3. Fetch verses for these versions
      final verses = await isar.bibles
          .filter()
          .bookEqualTo(bibleModel.book)
          .chapterEqualTo(bibleModel.chapter)
          .verseEqualTo(bibleModel.verse)
          .anyOf(
            candidateAbbrs,
            (q, String abbr) => q.versionEqualTo(abbr, caseSensitive: false),
          )
          .findAll();

      final verseMap = {
        for (final v in verses) v.version.toLowerCase(): v.text,
      };

      // 4. Combine data in the order of compareBooks
      return [
        for (final book in compareBooks)
          if (verseMap[book.abbr.toLowerCase()] != null)
            _CompareVerseItem(
              name: book.name,
              version: book.abbr,
              text: verseMap[book.abbr.toLowerCase()]!,
            ),
      ];
    } catch (e) {
      debugPrint('Error loading parallel verses: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final mq = MediaQuery.of(context);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        height: mq.size.height * 0.6,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _BottomSheetDragHandle(),
            _buildHeaderCard(context, colorScheme),
            const SizedBox(height: 16),
            Expanded(
              child: FutureBuilder<List<_CompareVerseItem>>(
                future: _loadParallelData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final results = snapshot.data ?? [];
                  if (results.isEmpty) {
                    return Center(
                      child: Text(
                        "No other active versions found.",
                        style: TextStyle(color: colorScheme.outline),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 8),
                    itemCount: results.length,
                    itemBuilder: (context, index) =>
                        _buildVerseItemCard(results[index], colorScheme),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, ColorScheme colorScheme) {
    final isLatin = Globals.bibleVersionLanguage == 'lat';
    final bookAbbr = BibleBooks.getBookAbbrByNumber(bibleModel.book);
    final reference =
        "${bibleModel.version.toUpperCase()} - $bookAbbr ${bibleModel.chapter}:${bibleModel.verse}";

    final content = Column(
      children: [
        Text(
          reference,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          bibleModel.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isLatin
            ? GestureDetector(
                onTap: () => showVerseWordsDialog(context, bibleModel),
                child: content,
              )
            : content,
      ),
    );
  }

  Widget _buildVerseItemCard(
    _CompareVerseItem item,
    ColorScheme colorScheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: _buildLeadingAvatar(item.version, colorScheme),
          title: Text(
            item.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              item.text,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingAvatar(String version, ColorScheme colorScheme) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          version.isNotEmpty ? version[0].toUpperCase() : '?',
          style: TextStyle(
            color: colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class _CompareVerseItem {
  const _CompareVerseItem({
    required this.name,
    required this.version,
    required this.text,
  });

  final String name;
  final String version;
  final String text;
}
