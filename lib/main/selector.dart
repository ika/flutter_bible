part of 'page.dart';

class HandleMainSelectorCode extends StatefulWidget {
  const HandleMainSelectorCode({super.key});

  @override
  State<HandleMainSelectorCode> createState() => HandleMainSelectorCodeState();
}

class HandleMainSelectorCodeState extends State<HandleMainSelectorCode> {
  late Map<int, String> allBooks;
  int chapterCount = 0;
  int verseCount = 0;

  static const double gridMarginSpacing = 16.0;
  static const double gridSpacing = 6.0;
  static const int gridLineCount = 4;

  static const String oldTestamentKey = 'OT';
  static const String newTestamentKey = 'NT';

  @override
  void initState() {
    super.initState();
    allBooks = BibleBooks.getAllBookNames();
  }

  void selectNewTestament() {
    setState(() {
      allBooks = BibleBooks.getNewTestamentNames();
    });
  }

  void selectOldTestament() {
    setState(() {
      allBooks = BibleBooks.getOldTestamentNames();
    });
  }

  void searchFilter(String value) {
    setState(() {
      allBooks = BibleBooks.searchBooks(value);
    });
  }

  Future<bool?> showVersesPopup(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        FocusScope.of(context).unfocus();
        return SafeArea(
          child: SizedBox(
            height: 500,
            child: Column(
              children: [
                const _BottomSheetDragHandle(),
                Expanded(
                  child: verseCount <= 0
                      ? Center(
                          child: Text(
                            'No verses',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: verseCount,
                          separatorBuilder: (_, _) => Divider(height: 1),
                          itemBuilder: (context, i) {
                            final verseNumber = i + 1;
                            return ListTile(
                              title: Text('Verse $verseNumber'),
                              onTap: () {
                                Globals.bibleVerseNumber = verseNumber;
                                Navigator.pop(context, true);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> showChaptersPopup(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        FocusScope.of(context).unfocus();
        return SafeArea(
          child: SizedBox(
            height: 500,
            child: Column(
              children: [
                const _BottomSheetDragHandle(),
                Expanded(
                  child: chapterCount <= 0
                      ? Center(
                          child: Text(
                            'No chapters',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: chapterCount,
                          separatorBuilder: (_, _) => Divider(height: 1),
                          itemBuilder: (context, i) {
                            final chapterNumber = i + 1;
                            return ListTile(
                              title: Text('Chapter $chapterNumber'),
                              onTap: () async {
                                Globals.bibleChapterNumber = chapterNumber;
                                Globals.bibleVerseNumber = 1;

                                final cnt = fetchVerseCount(
                                  version: Globals.bibleVersionName,
                                  book: Globals.bibleBookNumber,
                                  chapter: Globals.bibleChapterNumber,
                                );

                                verseCount = await cnt;

                                if (!context.mounted) {
                                  return;
                                }

                                final selectedVerse = await showVersesPopup(
                                  context,
                                );
                                if (selectedVerse == true && context.mounted) {
                                  Navigator.pop(context, true);
                                }
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget booksWidget() {
    return Padding(
      padding: const EdgeInsets.all(gridMarginSpacing),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => selectOldTestament(),
                child: const Text('Old Testament'),
              ),
              ElevatedButton(
                onPressed: () => selectNewTestament(),
                child: const Text('New Testament'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            onChanged: searchFilter,
            autofocus: false,
            decoration: const InputDecoration(
              hintText: 'Search versions...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemCount: allBooks.length,
              separatorBuilder: (_, _) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                final key = allBooks.keys.elementAt(index);
                final name = allBooks[key]!;
                return ListTile(
                  title: Text(name),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onTap: () async {
                    Globals.bibleBookName = name; // book name
                    Globals.bibleBookNumber = key; //
                    //debugPrint('key: $key, name: $name');
                    final cnt = await fetchChapterCount(
                      version: Globals.bibleVersionName,
                      book: Globals.bibleBookNumber,
                    );

                    chapterCount = cnt;

                    if (!context.mounted) {
                      return;
                    }

                    final selectedVerse = await showChaptersPopup(context);
                    if (selectedVerse == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          child: Column(
            children: [
              const _BottomSheetDragHandle(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
                  child: booksWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<int> fetchChapterCount({
    required String version,
    required int book,
  }) async {
    try {
      final List<int> chapters = await isar.bibles
          .filter()
          .versionEqualTo(version)
          .bookEqualTo(book)
          .chapterProperty()
          .findAll();

      return chapters.toSet().length;
    } catch (e) {
      debugPrint('Error fetching chapter count: $e');
      return 0;
    }
  }

  Future<int> fetchVerseCount({
    required String version,
    required int book,
    required int chapter,
  }) async {
    try {
      final List<int> verses = await isar.bibles
          .filter()
          .versionEqualTo(version)
          .bookEqualTo(book)
          .chapterEqualTo(chapter)
          .verseProperty()
          .findAll();

      return verses.toSet().length;
    } catch (e) {
      debugPrint('Error fetching verse count: $e');
      return 0;
    }
  }
}