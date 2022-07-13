import 'package:digitalbibleapp/high/hlModel.dart';
import 'package:digitalbibleapp/high/hlQueries.dart';
import 'package:flutter/material.dart';

// Bookmarks

HlQueries _hlQueries = HlQueries();

enum ConfirmAction { cancel, accept }

class HighLightsPage extends StatefulWidget {
  const HighLightsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HighLightsPage();
}

class _HighLightsPage extends State<HighLightsPage> {
  List<HlModel> list = List<HlModel>.empty();

  SnackBar hlDeletedSnackBar = const SnackBar(
    content: Text('HighLight Deleted!'),
  );

  Future highLightDialog(context, list) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete this highlight?'),
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
                Navigator.of(context).pop(ConfirmAction.accept);
              },
            ),
            TextButton(
              child: const Text('NO',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.cancel);
              },
            ),
          ],
        );
      },
    );
  }

  Widget showHighLightList(list, context) {
    GestureDetector makeListTile(list, int index) => GestureDetector(
          onHorizontalDragEnd: (DragEndDetails details) {
            if (details.primaryVelocity > 0 || details.primaryVelocity < 0) {
              highLightDialog(context, list[index]).then(
                (value) {
                  if (value == ConfirmAction.accept) {
                    _hlQueries.deleteHighLight(list[index].id).then(
                      (value) {
                        ScaffoldMessenger.of(context).showSnackBar(hlDeletedSnackBar);
                        setState(
                          () {
                            //list.removeAt(index);
                          },
                        );
                      },
                    );
                  }
                },
              );
            }
          },
          child: ListTile(
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
          ),
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HlModel>>(
      future: _hlQueries.getHighLightList(),
      builder: (context, AsyncSnapshot<List<HlModel>> snapshot) {
        if (snapshot.hasData) {
          list = snapshot.data;
          return showHighLightList(list, context);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
