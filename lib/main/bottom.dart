part of 'page.dart';

class BottomSheetWidget extends StatelessWidget {
  const BottomSheetWidget({super.key, required this.bibleModel});

  final Bible bibleModel;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    const tileContentPadding = EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 8,
    );
    const leadingSize = 50.0;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: mq.size.height * 0.8),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
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
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        (Globals.bibleVersionLanguage == 'lat')
                            ? GestureDetector(
                                onTap: () =>
                                    showVerseWordsDialog(context, bibleModel),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Action buttons section
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: tileContentPadding,
                    leading: Container(
                      width: leadingSize,
                      height: leadingSize,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'C',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Compare Verse'),
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
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: tileContentPadding,
                    leading: Container(
                      width: leadingSize,
                      height: leadingSize,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'B',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Bookmark Verse'),
                    onTap: () async {
                      Globals.type = 1;
                      Navigator.pop(context);
                      try {
                        await const BookmarkApi().addBookmark(bibleModel);
                        await BookmarkPreferences.saveLastBookmark(bibleModel);
                        if (!context.mounted) return;
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Bookmark added')),
                        );
                      } on BookmarkApiException catch (exception) {
                        if (!context.mounted) return;
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text(exception.message)),
                        );
                      }
                    },
                  ),
                ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: tileContentPadding,
                    leading: Container(
                      width: leadingSize,
                      height: leadingSize,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'H',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Highlight Verse'),
                    onTap: () async {
                      Globals.type = 2;
                      Navigator.pop(context);
                      try {
                        await const BookmarkApi().addBookmark(bibleModel);
                        await BookmarkPreferences.saveLastBookmark(bibleModel);
                        if (!context.mounted) return;
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Highlight added')),
                        );
                      } on BookmarkApiException catch (exception) {
                        if (!context.mounted) return;
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text(exception.message)),
                        );
                      }
                    },
                  ),
                ),
                if (Globals.bibleVersionLanguage == 'lat')
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
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'T',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      title: Text('Translate Verse'),
                      onTap: () async {
                        Navigator.pop(context);
                        final String verseText = bibleModel.text;
                        showDialog(
                          context: context,
                          builder: (dialogContext) => TranslationDialog(
                            verseText: verseText,
                            reference:
                                '${BibleBooks.getBookNameByNumber(bibleModel.book)} ${bibleModel.chapter}:${bibleModel.verse}',
                          ),
                        );
                      },
                    ),
                  ),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: tileContentPadding,
                    leading: Container(
                      width: leadingSize,
                      height: leadingSize,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          'C',
                          style: TextStyle(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    title: Text('Copy Verse'),
                    onTap: () async {
                      Navigator.pop(context);
                      final fullText =
                          '${bibleModel.text} ${BibleBooks.getBookNameByNumber(bibleModel.book)} ${bibleModel.chapter}:${bibleModel.verse}';
                      Clipboard.setData(ClipboardData(text: fullText));
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(content: Text('Text copied')),
                      );
                    },
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
