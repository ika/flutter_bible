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

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final title = switch (Globals.type) {
      1 => 'Bookmarks',
      2 => 'Highlights',
      _ => 'Type Error',
    };
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : list.isEmpty
                      ? Center(child: Text('No ${title.toLowerCase()} yet.'))
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            final bookmark = list[index];
                            final bookName = BibleBooks.getBookNameByNumber(
                              bookmark.book,
                            );

                            return Dismissible(
                              key: ValueKey(bookmark.id),
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                color: Theme.of(context).colorScheme.error,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                child: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).colorScheme.onError,
                                ),
                              ),
                              onDismissed: (direction) async {
                                setState(() {
                                  list.remove(bookmark);
                                });

                                try {
                                  final bookmarkId = bookmark.id;
                                  if (bookmarkId == null) {
                                    throw BookmarkApiException(
                                      '$title has no server ID.',
                                    );
                                  }
                                  await const BookmarkApi().deleteBookmark(
                                    bookmarkId,
                                  );
                                } on BookmarkApiException {
                                  if (!mounted) return;
                                  await loadData();
                                  debugPrint(
                                    'Error deleting $title: ${bookmark.id}',
                                  );
                                }
                              },
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                title: Text(
                                  '${bookmark.version.toUpperCase()} - $bookName ${bookmark.chapter}:${bookmark.verse}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    bookmark.text,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Globals.bibleVersionName = bookmark.version;
                                  Globals.bibleBookNumber = bookmark.book;
                                  Globals.bibleChapterNumber = bookmark.chapter;
                                  Globals.bibleVerseNumber = bookmark.verse;
                                  Globals.bibleVersionLanguage =
                                      Constants.bibleVersionsMap[bookmark
                                          .version]!['lang'] ??
                                      'eng';

                                  Navigator.pop(context, true);
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1, indent: 20),
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
