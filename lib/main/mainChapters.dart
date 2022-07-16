import 'package:digitalbibleapp/bmarks/bmModel.dart';
import 'package:digitalbibleapp/bmarks/bmQueries.dart';
import 'package:digitalbibleapp/cubit/chapters_cubit.dart';
import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/high/hlModel.dart';
import 'package:digitalbibleapp/high/hlQueries.dart';
import 'package:digitalbibleapp/main/dbModel.dart';
import 'package:digitalbibleapp/main/dbQueries.dart';
import 'package:digitalbibleapp/dialogs.dart';
import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

DbQueries _dbQueries; // Bible
PageController pageController;
SharedPrefs _sharedPrefs = SharedPrefs();
Dialogs _dialogs = Dialogs();
BmQueries _bmQueries = BmQueries();
HlQueries _hlQueries = HlQueries();

final ItemScrollController itemScrollController = ItemScrollController();
final ItemPositionsListener itemPositionsListener =
    ItemPositionsListener.create();

class MainChapters extends StatefulWidget {
  const MainChapters({Key key}) : super(key: key);

  @override
  State<MainChapters> createState() => _MainChaptersState();
}

class _MainChaptersState extends State<MainChapters> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToIndex(10));
  }

  void scrollToIndex(int idx) {
    if (itemScrollController.isAttached) {
      itemScrollController.jumpTo(index: idx);
      // itemScrollController.scrollTo(
      //     index: idx,
      //     duration: const Duration(milliseconds: 200),
      //     curve: Curves.easeInOutCubic);
    } else {
      print('temScrollController in NOT attached');
    }
  }

  Future<List<Bible>> getBookText(int book, int ch) async {
    return await _dbQueries.getBookChapter(book, ch);
  }

  Future<List<Bible>> getVersionText(int book, int ch) async {
    List<Bible> bible = List<Bible>.empty();

    Future<List<Bible>> _futureBibleList = getBookText(book, ch);
    bible = await _futureBibleList;
    return bible;
  }

  Color colorSelector(int index) {
    // if (index + 1 == Globals.chapterVerse) {
    //   Globals.chapterVerse = 0;
    //   return Colors.lightGreenAccent;
    // } else {
    //   Globals.chapterVerse = 0;
    //   return Colors.white;
    // }
    return Colors.white;
  }

  SnackBar bmSnackBar = const SnackBar(
    content: Text('Book Mark Saved!'),
  );

  SnackBar hlSnackBar = const SnackBar(
    content: Text('Highlight Saved!'),
  );

  saveBookMark() {
    List<String> stringTitle = [
      Globals.verAbbr,
      ' ',
      Globals.bookName,
      ' ',
      '${Globals.bookChapter}',
      ':',
      '${Globals.verseNumber}'
    ];

    final model = BmModel(
      //id: 0,
      title: stringTitle.join(),
      subtitle: Globals.verseText,
      version: Globals.bibleVersion,
      book: Globals.bibleBook,
      chapter: Globals.bookChapter,
      verse: Globals.verseNumber,
    );
    _bmQueries.saveBookMark(model).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(bmSnackBar);
      },
    );
  }

  saveHighLight() {
    List<String> stringTitle = [
      Globals.verAbbr,
      ' ',
      Globals.bookName,
      ' ',
      '${Globals.bookChapter}',
      ':',
      '${Globals.verseNumber}'
    ];

    final model = HlModel(
      //id: 0,
      title: stringTitle.join(),
      subtitle: Globals.verseText,
      version: Globals.bibleVersion,
      book: Globals.bibleBook,
      chapter: Globals.bookChapter,
      verse: Globals.verseNumber,
    );
    _hlQueries.saveHighLight(model).then(
      (value) {
        ScaffoldMessenger.of(context).showSnackBar(hlSnackBar);
      },
    );
  }

  Widget showListView(int book, int ch) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: FutureBuilder<List<Bible>>(
        future: getVersionText(book, ch),
        builder: (context, AsyncSnapshot<List<Bible>> snapshot) {
          if (snapshot.hasData) {
            return ScrollablePositionedList.builder(
              //return ListView.builder(
              itemCount: snapshot.data.length,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Globals.verseNumber = snapshot.data[index].v;
                    Globals.verseText = snapshot.data[index].t;
                    _dialogs.contextDialog(context).then(
                      (value) {
                        switch (value) {
                          case 0: // compare
                            break;
                          case 1: // bookmarks
                            saveBookMark();
                            break;
                          case 2: // highlight
                            saveHighLight();
                            break;
                          default:
                            break;
                        }
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: Text(
                            '${snapshot.data[index].v}. ${snapshot.data[index].t}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          margin: const EdgeInsets.only(bottom: 6.0),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> chapterCountFunc(int book, int chapterCount) {
    List<Widget> pagesList = [];
    for (int ch = 1; ch <= chapterCount; ch++) {
      pagesList.add(showListView(book, ch));
    }
    return pagesList;
  }

  Widget chaptersList(int book) {
    return FutureBuilder<int>(
      future: _dbQueries.getChapterCount(book),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          int chapterCount = snapshot.data.toInt();
          return PageView(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            pageSnapping: true,
            physics: const BouncingScrollPhysics(),
            children: chapterCountFunc(book, chapterCount),
            onPageChanged: (index) {
              int c = index + 1;
              _sharedPrefs.saveChapter(c).then(
                (value) {
                  Globals.bookChapter = c;
                  BlocProvider.of<ChapterCubit>(context).setChapter(c);
                },
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    pageController = PageController(initialPage: Globals.bookChapter - 1);
    _dbQueries = DbQueries();
    return showListView(1, 1); //chaptersList(Globals.bibleBook); // Bible book
  }
}
