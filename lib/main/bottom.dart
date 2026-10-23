part of 'page.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key, required this.bibleModel});

  final Bible bibleModel;

  Future<void> _saveBookmark(
    BuildContext context,
    ScaffoldMessengerState scaffoldMessenger,
    int type,
    String successMessage,
  ) async {
    Globals.type = type;
    Navigator.pop(context);
    try {
      await const BookmarkApi().addBookmark(bibleModel);
      await BookmarkPreferences.saveLastBookmark(bibleModel);
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
    } on BookmarkApiException catch (exception) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(exception.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final isLatin = Globals.bibleVersionLanguage == 'lat';

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.8),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _BottomSheetDragHandle(),
                // Verse info section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: isLatin
                        ? () => showVerseWordsDialog(context, bibleModel)
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                ),
                const SizedBox(height: 16),
                // Action buttons section
                _MenuCard(
                  symbol: 'C',
                  title: 'Compare Verse',
                  onTap: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) =>
                          CompareVersesSheet(bibleModel: bibleModel),
                    );
                  },
                ),
                _MenuCard(
                  symbol: 'B',
                  title: 'Bookmark Verse',
                  onTap: () => _saveBookmark(
                    context,
                    scaffoldMessenger,
                    1,
                    'Bookmark added',
                  ),
                ),
                _MenuCard(
                  symbol: 'H',
                  title: 'Highlight Verse',
                  onTap: () => _saveBookmark(
                    context,
                    scaffoldMessenger,
                    2,
                    'Highlight added',
                  ),
                ),
                if (isLatin)
                  _MenuCard(
                    symbol: 'T',
                    title: 'Translate Verse',
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (dialogContext) => TranslationDialog(
                          verseText: bibleModel.text,
                          reference:
                              '${BibleBooks.getBookNameByNumber(bibleModel.book)} ${bibleModel.chapter}:${bibleModel.verse}',
                        ),
                      );
                    },
                  ),
                _MenuCard(
                  symbol: 'C',
                  title: 'Copy Verse',
                  onTap: () {
                    Navigator.pop(context);
                    final fullText =
                        '${bibleModel.text} ${BibleBooks.getBookNameByNumber(bibleModel.book)} ${bibleModel.chapter}:${bibleModel.verse}';
                    Clipboard.setData(ClipboardData(text: fullText));
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Text copied')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
