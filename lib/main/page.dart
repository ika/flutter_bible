//----------------------------------------
// Main Page
//----------------------------------------

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bookmarks/preferences.dart';
import '../bookmarks/service.dart';
import '../collections/bible.dart';
import '../collections/booklist.dart';
import '../collections/bookmark.dart';
import '../constants.dart';
import '../database.dart';
import '../globals.dart';
import '../langs/books.dart';
import '../translate/page.dart';

part './compare.dart';
part './versions.dart';
part './selector.dart';
part './bookmarks.dart';
part './bottom.dart';
part './menu.dart';
part './booksel.dart';
part './search.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  late Future<List<_Chapter>> _chaptersFuture;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _chaptersFuture = _loadChapters();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  Future<List<_Chapter>> _loadChapters() async {
    final List<Bible> verses = await isar.bibles
        .filter()
        .versionEqualTo(Globals.bibleVersionName)
        .bookEqualTo(Globals.bibleBookNumber)
        .sortByChapter()
        .thenByVerse()
        .findAll();

    final chapters = <_Chapter>[];
    for (final verse in verses) {
      if (chapters.isEmpty ||
          chapters.last.book != verse.book ||
          chapters.last.number != verse.chapter) {
        chapters.add(
          _Chapter(book: verse.book, number: verse.chapter, verses: []),
        );
      }
      chapters.last.verses.add(verse);
    }
    return chapters;
  }

  void _refreshAfterSelection() {
    _pageController?.dispose();
    _pageController = null;
    _chaptersFuture = _loadChapters();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _handleMenu() async {
    final menuAction = await showModalBottomSheet<_MenuAction>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MenuBottomSheet(),
    );

    if (!mounted) return;

    switch (menuAction) {
      case _MenuAction.bookmarks:
        await _handleBookmark();
      case _MenuAction.selector:
        await _handleSelector();
      case _MenuAction.books:
        await _handleBooks();
      case _MenuAction.search:
        await _handleSearch();
      case null:
        break;
    }
  }

  Future<void> _handleBooks() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HandleBookListCode(),
    );

    if (result == true && mounted) {
      _refreshAfterSelection();
    }
  }

  Future<void> _handleSearch() async {
    final searchReturn = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HandleSearchCode(),
    );

    if (searchReturn == true && mounted) {
      _refreshAfterSelection();
    }
  }

  Future<void> _handleVersions() async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          HandleVersionsCode(onVersionSelected: _refreshAfterSelection),
    );
  }

  Future<void> _handleSelector() async {
    final selectedVerse = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HandleMainSelectorCode(),
    );

    if (selectedVerse == true && mounted) {
      _refreshAfterSelection();
    }
  }

  Future<void> _handleBookmark() async {
    final selectedBookmark = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const HandleBookmarksCode(),
    );

    if (selectedBookmark == true && mounted) {
      _refreshAfterSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.inversePrimary,
        title: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _handleVersions,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${Globals.bibleVersionName.toUpperCase()} · ${BibleBooks.getBookAbbrByNumber(Globals.bibleBookNumber)} ${BibleBooks.formatNameInLanguage(Globals.bibleChapterNumber)}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_drop_down, size: 20),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu',
            onPressed: _handleMenu,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<_Chapter>>(
          future: _chaptersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No verses found.'));
            } else {
              final chapters = snapshot.data!;

              final initialChapterIndex = chapters.indexWhere(
                (c) =>
                    c.book == Globals.bibleBookNumber &&
                    c.number == Globals.bibleChapterNumber,
              );

              final effectiveInitialIndex = initialChapterIndex != -1
                  ? initialChapterIndex
                  : 0;

              _pageController ??= PageController(
                initialPage: effectiveInitialIndex,
              );

              return PageView.builder(
                controller: _pageController,
                itemCount: chapters.length,
                physics: const BouncingScrollPhysics(),
                pageSnapping: true,
                onPageChanged: (index) {
                  final chapter = chapters[index];
                  setState(() {
                    Globals.bibleBookNumber = chapter.book;
                    Globals.bibleChapterNumber = chapter.number;
                    Globals.bibleVerseNumber = 1;
                  });
                },
                itemBuilder: (context, index) =>
                    _ChapterView(chapter: chapters[index]),
              );
            }
          },
        ),
      ),
    );
  }
}

class _Chapter {
  const _Chapter({
    required this.book,
    required this.number,
    required this.verses,
  });

  final int book;
  final int number;
  final List<Bible> verses;

  String get title => 'Chapter $number';
}

class _ChapterView extends StatefulWidget {
  const _ChapterView({required this.chapter});

  final _Chapter chapter;

  @override
  State<_ChapterView> createState() => _ChapterViewState();
}

class _ChapterViewState extends State<_ChapterView> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  StreamSubscription<void>? _bookmarkSubscription;
  // Map of verse number to bookmark type (1 = bookmark, 2 = highlight)
  Map<int, int> _markedVerses = {};

  Future<void> _handleVerseActions(Bible bibleModel) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BottomSheetWidget(bibleModel: bibleModel),
    );
    if (mounted) {
      _loadMarkedVerses();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMarkedVerses();
    // Listen to changes in the local bookmark collection
    _bookmarkSubscription = isar.localBookmarks.watchLazy().listen((_) {
      if (mounted) {
        _loadMarkedVerses();
      }
    });

    if (Globals.bibleVerseNumber > 1) {
      _scrollWithDelay();
    }
  }

  @override
  void dispose() {
    _bookmarkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadMarkedVerses() async {
    try {
      final records = await isar.localBookmarks
          .filter()
          .versionEqualTo(Globals.bibleVersionName)
          .bookEqualTo(widget.chapter.book)
          .chapterEqualTo(widget.chapter.number)
          .not()
          .syncStatusEqualTo(2)
          .findAll();

      final map = <int, int>{};
      for (final r in records) {
        // If a verse has both bookmark (1) and highlight (2), highlight takes priority
        final existingType = map[r.verse];
        if (existingType == null || r.type == 2) {
          map[r.verse] = r.type;
        }
      }

      if (mounted) {
        setState(() {
          _markedVerses = map;
        });
      }
    } catch (e) {
      debugPrint('Error loading marked verses: $e');
    }
  }

  int _initialScrollIndex() {
    final verseNumber = Globals.bibleVerseNumber;
    if (verseNumber <= 1) {
      return 0;
    }
    if (verseNumber > widget.chapter.verses.length) {
      return widget.chapter.verses.length - 1;
    }
    return verseNumber - 1;
  }

  void _scrollWithDelay() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!mounted || !_itemScrollController.isAttached) {
          return;
        }
        _itemScrollController.scrollTo(
          index: _initialScrollIndex(),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeInOutCubic,
        );
      });
    });
  }

  @override
  void didUpdateWidget(covariant _ChapterView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((oldWidget.chapter.number != widget.chapter.number ||
            oldWidget.chapter.book != widget.chapter.book) &&
        Globals.bibleVerseNumber > 1) {
      _scrollWithDelay();
    }
    if (oldWidget.chapter.number != widget.chapter.number ||
        oldWidget.chapter.book != widget.chapter.book) {
      _loadMarkedVerses();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ScrollablePositionedList.builder(
      itemScrollController: _itemScrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      initialScrollIndex: _initialScrollIndex(),
      itemCount: widget.chapter.verses.length + 1,
      itemBuilder: (context, index) {
        if (index == widget.chapter.verses.length) {
          return const SizedBox(
            height: 240, // Provides scroll room at the bottom
          );
        }

        final verse = widget.chapter.verses[index];
        final markType = _markedVerses[verse.verse];

        Color? backgroundColor;
        if (markType == 2) {
          backgroundColor = colorScheme.tertiaryContainer;
        } else if (markType == 1) {
          backgroundColor = colorScheme.primaryContainer;
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Material(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => _handleVerseActions(verse),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                child: Text.rich(
                  TextSpan(
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      fontSize: 16,
                    ),
                    children: [
                      TextSpan(
                        text: '${BibleBooks.formatNumberInLanguage(verse.verse)} ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      TextSpan(
                        text: verse.text,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BottomSheetDragHandle extends StatelessWidget {
  const _BottomSheetDragHandle();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

void showVerseWordsDialog(BuildContext context, Bible bibleModel) {
  Navigator.pop(context);
  final rawWords = bibleModel.text.trim().split(RegExp(r'\s+'));
  final words = rawWords
      .map(
        (w) => w.replaceAll(
          RegExp(r'^[^a-zA-Z0-9\u00C0-\u024F]+|[^a-zA-Z0-9\u00C0-\u024F]+$'),
          '',
        ),
      )
      .where((w) => w.isNotEmpty)
      .toList();

  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        '${BibleBooks.getBookAbbrByNumber(bibleModel.book)} ${bibleModel.chapter}:${bibleModel.verse}',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bibleModel.text),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: words
                  .map(
                    (word) => ActionChip(
                      label: Text(word),
                      onPressed: () =>
                          _onWordTap(dialogContext, bibleModel, word),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

void _onWordTap(BuildContext context, Bible bibleModel, String word) {
  Navigator.pop(context);
  showDialog(
    context: context,
    builder: (dialogContext) => TranslationDialog(
      verseText: word,
      reference:
          '${BibleBooks.getBookNameByNumber(bibleModel.book)} ${bibleModel.chapter}:${bibleModel.verse}',
    ),
  );
}

