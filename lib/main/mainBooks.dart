import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/langs/lkModel.dart';
import 'package:digitalbibleapp/langs/lkQueries.dart';
import 'package:flutter/material.dart';

LkQueries lkQueries = LkQueries();

class MainBooks extends StatefulWidget {
  const MainBooks({Key key}) : super(key: key);

  @override
  State<MainBooks> createState() => _MainBooksState();
}

class _MainBooksState extends State<MainBooks>
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

  Widget booksWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<List<LKeyModel>>(
        future: lkQueries.getBookList(Globals.bibleLang),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
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
            Center(child: booksWidget()),
            const Center(child: Text('tab two')),
            const Center(child: Text('tab three')),
          ],
        ),
      );
}
