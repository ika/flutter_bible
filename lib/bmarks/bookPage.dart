import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:digitalbibleapp/bmarks/bmModel.dart';
import 'package:digitalbibleapp/bmarks/bmQueries.dart';
import 'package:digitalbibleapp/main/mainPage.dart';

// Bookmarks

BmQueries _bmQueries = BmQueries();

enum ConfirmAction { CANCEL, ACCEPT }

int v; // bible version number, kjv
int b; // book
int c; // chapter

class BookMarksPage extends StatefulWidget {
  const BookMarksPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookMarkState();
}

class _BookMarkState extends State<BookMarksPage> {
  List<BmModel> list = List<BmModel>.empty();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BmModel>>(
      future: _bmQueries.getBookMarkList(),
      builder: (context, AsyncSnapshot<List<BmModel>> snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data;
          return showChapterList(list, context);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future _showDialog(context, list) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this bookmark?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(list.title),
                Text(list.subtitle),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('YES',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            ),
            TextButton(
              child: const Text('NO',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
          ],
        );
      },
    );
  }

  Widget showChapterList(list, context) {
    ListTile makeListTile(list, int index) => ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          title: Text(
            list[index].title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.linear_scale, color: Colors.amber),
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  strutStyle: const StrutStyle(fontSize: 12.0),
                  text: TextSpan(
                      style: const TextStyle(color: Colors.white),
                      text: " " + list[index].subtitle),
                ),
              ),
            ],
          ),
          trailing: const Icon(Icons.keyboard_arrow_right,
              color: Colors.white, size: 30.0),
          onTap: () {
            // _saveVersion(list[index].version);
            // _saveBook(list[index].book);
            // _saveChapter(list[index].chapter);

            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const MainPageCall(),
              ),
            );
            // list[index].version,
            // list[index].book,
            // list[index].chapter))).then((value) {});
          },
          onLongPress: () {
            _showDialog(context, list[index]).then(
              (value) {
                if (value == ConfirmAction.ACCEPT) {
                  _bmQueries.deleteBookMark(list[index].id).then(
                    (value) {
                      setState(
                        () {
                          list.removeAt(index);
                        },
                      );
                    },
                  );
                }
              },
            );
          },
        );

    Card makeCard(list, int index) => Card(
          elevation: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
          child: Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(list, index),
          ),
        );

    final makeBody = ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(list, index);
      },
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: const Color.fromRGBO(64, 75, 96, .9),
      title: const Text('Bookmarks'),
    );

    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: topAppBar,
      body: makeBody,
    );
  }
}
