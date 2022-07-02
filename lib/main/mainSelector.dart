import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/langs/lkModel.dart';
import 'package:digitalbibleapp/langs/lkQueries.dart';
import 'package:digitalbibleapp/main/dbQueries.dart';
import 'package:flutter/material.dart';

LkQueries lkQueries = LkQueries();
DbQueries dbQueries = DbQueries();

class MainSelector extends StatefulWidget {
  const MainSelector({Key key}) : super(key: key);

  @override
  State<MainSelector> createState() => _MainSelectorState();
}

class _MainSelectorState extends State<MainSelector>
    with SingleTickerProviderStateMixin {
  TabController tabController;

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
                  int chap = index + 1;
                  return Center(
                    child: Text(
                      '$chap',
                      style: const TextStyle(
                          fontSize: 18.0), //fontWeight: FontWeight.bold),
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
                        tabController.animateTo(2);
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
                    tabController.animateTo(1);
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

  List<String> tabNames = ['Books', 'Chapters', 'Verses'];

  @override
  Widget build(BuildContext context) => Scaffold(
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
      );
}
