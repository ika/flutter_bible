part of './page.dart';

class CompareVersesSheet extends StatelessWidget {
  const CompareVersesSheet({super.key, required this.bibleModel});

  final Bible bibleModel;

  Future<List<Map<String, dynamic>>> _loadParallelData(
    BuildContext context,
  ) async {
    try {
      // 1. Get the current active version from Bloc
      final currentVersion = Globals.bibleVersionName;

      // 2. Get compare versions from constants map, excluding the current one
      final activeAbbrs = Constants.bibleVersionsMap.keys
          .where((abbr) => abbr != currentVersion)
          .toList();

      if (activeAbbrs.isEmpty) return [];

      final nameMap = {
        for (final entry in Constants.bibleVersionsMap.entries)
          entry.key: entry.value['name'] ?? entry.key,
      };

      // 3. Fetch verses for these versions
      final verses = await isar.bibles
          .filter()
          .bookEqualTo(bibleModel.book)
          .chapterEqualTo(bibleModel.chapter)
          .verseEqualTo(bibleModel.verse)
          .anyOf(activeAbbrs, (q, String abbr) => q.versionEqualTo(abbr))
          .findAll();

      // 4. Combine data
      return verses.map((v) {
        return {
          'text': v.text,
          'version': v.version,
          'name': nameMap[v.version] ?? v.version,
        };
      }).toList();
    } catch (e) {
      debugPrint('Error loading parallel verses: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _BottomSheetDragHandle(),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: (Globals.bibleVersionLanguage == 'lat')
                  ? GestureDetector(
                      onTap: () => showVerseWordsDialog(context, bibleModel),
                      child: Column(
                        children: [
                          Text(
                            "${bibleModel.version.toUpperCase()} - ${BibleBooks.getBookAbbrByNumber(bibleModel.book)} ${bibleModel.chapter}:${bibleModel.verse}",
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
                      ),
                    )
                  : Column(
                      children: [
                        Text(
                          "${bibleModel.version.toUpperCase()} - ${BibleBooks.getBookAbbrByNumber(bibleModel.book)} ${bibleModel.chapter}:${bibleModel.verse}",
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
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadParallelData(context),
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
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
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
                          title: Text(
                            item['name'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            item['text'],
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
