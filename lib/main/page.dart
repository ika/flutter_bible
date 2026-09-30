//----------------------------------------
// Main Page
//----------------------------------------

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bookmarks/preferences.dart';
import '../bookmarks/service.dart';
import '../collections/bible.dart';
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
    setState(() {});
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
        await _handleBookmark(); // bookmarks =1 highlights =2
      case _MenuAction.selector:
        await _handleSelector();
      case _MenuAction.search:
        await _handleSearch();
      case null:
        break;
    }
  }

  Future<void> _handleSearch() async {
    final searchReturn = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => HandleSearchCode(),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(4),
              onTap: _handleVersions,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Text(Globals.bibleVersionName.toUpperCase()),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${BibleBooks.getBookAbbrByNumber(Globals.bibleBookNumber)} ${BibleBooks.formatNameInLanguage(Globals.bibleChapterNumber)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            tooltip: 'Menu',
            onPressed: _handleMenu,
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
        ),
        child: FutureBuilder<List<_Chapter>>(
          future: _chaptersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No chapters found.'));
            } else {
              final chapters = snapshot.data!;

              _pageController ??= PageController(
                initialPage: Globals.bibleChapterNumber - 1,
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
  _Chapter({required this.book, required this.number, required this.verses});

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

  void _handleVerseActions(Bible bibleModel) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BottomSheetWidget(bibleModel: bibleModel),
    );
  }

  @override
  void initState() {
    super.initState();
    if (Globals.bibleVerseNumber > 1) {
      _scrollWithDelay();
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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScrollablePositionedList.builder(
        itemScrollController: _itemScrollController,
        padding: const EdgeInsets.all(24),
        initialScrollIndex: 0,
        itemCount: widget.chapter.verses.length + 1,
        itemBuilder: (context, index) {
          if (index == widget.chapter.verses.length) {
            return const SizedBox(
              height: 480,
            ); // Provides scroll room equivalent to ~20 empty lines
          }

          final verse = widget.chapter.verses[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: '${BibleBooks.formatNumberInLanguage(verse.verse)} ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: verse.text,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => _handleVerseActions(verse),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _BottomSheetDragHandle extends StatelessWidget {
  const _BottomSheetDragHandle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

void showVerseWordsDialog(BuildContext context, Bible bibleModel) {
  Navigator.pop(context);
  final words = bibleModel.text
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
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
