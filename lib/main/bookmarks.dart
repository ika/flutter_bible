part of 'page.dart';

class HandleBookmarksCode extends StatefulWidget {
  const HandleBookmarksCode({super.key});

  @override
  HandleBookmarksCodeState createState() => HandleBookmarksCodeState();
}

class HandleBookmarksCodeState extends State<HandleBookmarksCode> {
  List<Bookmark> list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final bookmarks = await const BookmarkApi().getBookmarks();
      if (!mounted) return;
      setState(() {
        list = bookmarks;
        isLoading = false;
      });
    } on BookmarkApiException {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteBookmark(
    Bookmark bookmark,
    String itemTitle,
    ScaffoldMessengerState scaffoldMessenger,
  ) async {
    final originalIndex = list.indexOf(bookmark);
    setState(() {
      list.remove(bookmark);
    });

    try {
      final bookmarkId = bookmark.id;
      if (bookmarkId == null) {
        throw BookmarkApiException('$itemTitle has no ID.');
      }
      await const BookmarkApi().deleteBookmark(bookmarkId);
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('$itemTitle deleted'),
          duration: const Duration(seconds: 2),
        ),
      );
    } on BookmarkApiException catch (e) {
      if (!mounted) return;
      if (originalIndex != -1 && !list.contains(bookmark)) {
        setState(() {
          list.insert(originalIndex, bookmark);
        });
      }
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to delete: ${e.message}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final isHighlight = Globals.type == 2;
    final title = isHighlight ? 'Highlights' : 'Bookmarks';
    final singularTitle = isHighlight ? 'Highlight' : 'Bookmark';

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height * 0.8),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, bottomInset + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _BottomSheetDragHandle(),
              const SizedBox(height: 4),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Tap to open, swipe to delete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : list.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isHighlight
                                  ? Icons.highlight_outlined
                                  : Icons.bookmark_border,
                              size: 48,
                              color: colorScheme.outline,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'No ${title.toLowerCase()} yet',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: list.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final bookmark = list[index];
                          final bookName = BibleBooks.getBookNameByNumber(
                            bookmark.book,
                          );
                          final scaffoldMessenger =
                              ScaffoldMessenger.of(context);

                          return Dismissible(
                            key: ValueKey(bookmark.id ?? bookmark.hashCode),
                            direction: DismissDirection.horizontal,
                            background: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.error,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: colorScheme.onError,
                              ),
                            ),
                            secondaryBackground: Container(
                              decoration: BoxDecoration(
                                color: colorScheme.error,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Icon(
                                Icons.delete_outline,
                                color: colorScheme.onError,
                              ),
                            ),
                            onDismissed: (_) => _deleteBookmark(
                              bookmark,
                              singularTitle,
                              scaffoldMessenger,
                            ),
                            child: Card(
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
                                  vertical: 6,
                                ),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primaryContainer,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      bookmark.version.toUpperCase(),
                                      style: TextStyle(
                                        color: colorScheme.onPrimaryContainer,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  '$bookName ${bookmark.chapter}:${bookmark.verse}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    bookmark.text,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.chevron_right,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                onTap: () {
                                  final versionKey =
                                      bookmark.version.toLowerCase();
                                  final lang = Constants.bibleVersionsMap[
                                          versionKey]?['lang'] ??
                                      'eng';
                                  Globals.bibleVersionName = versionKey;
                                  Globals.bibleBookNumber = bookmark.book;
                                  Globals.bibleChapterNumber = bookmark.chapter;
                                  Globals.bibleVerseNumber = bookmark.verse;
                                  Globals.bibleVersionLanguage = lang;

                                  Navigator.pop(context, true);
                                },
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
