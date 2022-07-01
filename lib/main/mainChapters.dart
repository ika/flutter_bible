import 'package:digitalbibleapp/cubit/chapters_cubit.dart';
import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/main/dbModel.dart';
import 'package:digitalbibleapp/main/dbQueries.dart';
import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

DbQueries _dbQueries; // Bible
Globals globals = Globals();
PageController pageController;
SharedPrefs _sharedPrefs = SharedPrefs();

// class MainChapters extends StatefulWidget {
//   const MainChapters({Key key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _MainChaptersState();
// }
//
// class _MainChaptersState extends State<MainChapters> {
//
//   @override
//   void initState() {
//     _dbQueries = DbQueries();
//     super.initState();
//   }

class MainChapters extends StatelessWidget {
  const MainChapters({Key key}) : super(key: key);

  Future<List<Bible>> getBookText(int book, int ch) async {
    return await _dbQueries.getBookChapter(book, ch);
  }

  Future<List<Bible>> getVersionText(int book, int ch) async {
    List<Bible> bible = List<Bible>.empty();

    Future<List<Bible>> _futureBibleList = getBookText(book, ch);
    bible = await _futureBibleList;
    return bible;
  }

  Widget showListView(int book, int ch) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: FutureBuilder<List<Bible>>(
        future: getVersionText(book, ch),
        builder: (context, AsyncSnapshot<List<Bible>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  // onTap: () {
                  //   showContextDialog(
                  //       snapshot.data[index].v, snapshot.data[index].t);
                  // },
                  // onLongPress: () {
                  //   print('LONG PRESS');
                  // },
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

  Widget thisChapterView(int book) {
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
            onPageChanged: (index) {
              int c = index + 1;
              _sharedPrefs.saveChapter(c).then(
                (value) {
                  BlocProvider.of<ChapterCubit>(context).setChapter(c);
                },
              );
            },
            children: chapterCountFunc(book, chapterCount),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void setPageController() {
    _sharedPrefs.readChapter().then(
      (c) {
        pageController = PageController(initialPage: c - 1);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _dbQueries = DbQueries();
    setPageController();
    return thisChapterView(43);
  }
}
