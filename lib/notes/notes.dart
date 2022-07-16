import 'dart:async';
import 'package:digitalbibleapp/notes/edit.dart';
import 'package:digitalbibleapp/notes/model.dart';
import 'package:digitalbibleapp/notes/nQueries.dart';
import 'package:digitalbibleapp/utils/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

NtQueries _ntQueries = NtQueries();
Utilities _utilities = Utilities();

class NotesPage extends StatefulWidget {
  const NotesPage({Key key}) : super(key: key);

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  FutureOr onReturnFromEdit(dynamic value) {
    // update notes
    setState(() {});
  }

  _navigateToEditPage(NtModel model) async {
    Route route =
        CupertinoPageRoute(builder: (context) => EditPage(model: model));
    Future.delayed(
      Duration.zero,
      () {
        Navigator.push(context, route).then(onReturnFromEdit);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: hexToColor("#f5f0e1"),
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: FutureBuilder<List<NtModel>>(
              future: _ntQueries.getAllNotes(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<NtModel>> snapshot) {
                // Make sure data exists and is actually loaded
                if (snapshot.hasData) {
                  // If there are no notes.
                  if (snapshot.data.isEmpty) {
                    //_navigateToEditPage(Model(id: null, contents: ''));
                    return const Center(
                      child: Text('No items found!'),
                    );
                  }

                  List<NtModel> notes = snapshot.data;

                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      NtModel model = notes[index];
                      return Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              _utilities.reduceLength(30, model.contents),
                            ),
                            onTap: () {
                              _navigateToEditPage(model);
                            },
                            leading: const Icon(Icons.chevron_right,
                                color: Colors.orangeAccent),
                          ),
                          const Divider(
                            height: 2.0,
                            indent: 15.0,
                            endIndent: 20.0,
                          ),
                        ],
                      );
                    },
                  );
                }

                return const Center(
                  child: Text('An error has occured!'),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange[900],
        onPressed: () {
          _navigateToEditPage(NtModel(id: null, contents: null));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
