import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/langs/lkModel.dart';
import 'package:digitalbibleapp/langs/lkQueries.dart';
import 'package:digitalbibleapp/main/dbQueries.dart';
import 'package:digitalbibleapp/main/mainPage.dart';
import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

LkQueries lkQueries = LkQueries();
DbQueries dbQueries = DbQueries();
SharedPrefs sharedPrefs = SharedPrefs();

class MainSelector extends StatefulWidget {
  const MainSelector({Key key}) : super(key: key);

  @override
  State<MainSelector> createState() => _MainSelectorState();
}

class _MainSelectorState extends State<MainSelector>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  List<String> tabNames = ['Books', 'Chapters', 'Verses'];

  @override
  initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  backButton(BuildContext context) {
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const MainPageCall(),
          ),
        );
      },
    );
  }

  Widget versesWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<int>(
        future: dbQueries.getVerseCount(Globals.bibleBook, Globals.bookChapter),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 5,
              children: List.generate(
                snapshot.data,
                (index) {
                  int verse = index + 1;
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Globals.chapterVerse = index;
                        Globals.scrollTo = true;
                        backButton(context);
                      },
                      child: Text(
                        '$verse',
                        style: const TextStyle(
                            fontSize: 18.0), //fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget chaptersWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<int>(
        future: dbQueries.getChapterCount(Globals.bibleBook),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
              crossAxisCount: 5,
              children: List.generate(
                snapshot.data,
                (index) {
                  int chap = index + 1;
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        // save chapter
                        sharedPrefs.saveChapter(chap).then(
                          (value) {
                            Globals.bookChapter = chap;
                            tabController.animateTo(2);
                            //backButton(context);
                          },
                        );
                      },
                      child: Text(
                        '$chap',
                        style: const TextStyle(
                            fontSize: 18.0), //fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget booksWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<List<LKeyModel>>(
        future: lkQueries.getBookList(Globals.bibleLang),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    snapshot.data[index].n,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  onTap: () {
                    int book = snapshot.data[index].b;
                    // save book
                    sharedPrefs.saveBook(book).then(
                      (value) {
                        Globals.bibleBook = book;
                        // save chapter
                        sharedPrefs.saveChapter(1).then(
                          (value) {
                            Globals.bookChapter = Globals.chapterVerse = 1;
                            tabController.animateTo(1);
                          },
                        );
                      },
                    );
                  },
                  trailing: const Icon(Icons.arrow_right),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        backButton(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(64, 75, 96, .9),
          elevation: 0.1,
          title: Text(tabNames[tabController.index]),
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(text: tabNames[0]),
              Tab(text: tabNames[1]),
              Tab(text: tabNames[2]),
            ],
          ),
        ),
        body: TabBarView(
          controller: tabController,
          children: [
            Center(
              child: booksWidget(),
            ),
            Center(
              child: chaptersWidget(),
            ),
            Center(
              child: versesWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
