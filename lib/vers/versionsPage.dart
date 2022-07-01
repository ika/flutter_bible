import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/main/dbProvider.dart';
import 'package:digitalbibleapp/utils/utilities.dart';
import 'package:digitalbibleapp/vers/vkModel.dart';
import 'package:digitalbibleapp/vers/vkProvider.dart';
import 'package:digitalbibleapp/vers/vkQueries.dart';
import 'package:flutter/material.dart';

DbProvider dbProvider = DbProvider();
VkQueries vkQueries = VkQueries();
Utilities utilities = Utilities();

Future<void> updateActivate(int active, int ver) async {
  vkQueries.updateActiveState(active, ver);
}

class VersionsPage extends StatefulWidget {
  const VersionsPage({Key key}) : super(key: key);

  @override
  _VersionsPageState createState() => _VersionsPageState();
}

class _VersionsPageState extends State<VersionsPage> {
  void initStage() {}

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  Widget versionsWidget() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<List<VkModel>>(
        future: vkQueries.getAllVkVersions(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  title: Text(
                    snapshot.data[index].m,
                  ),
                  value: snapshot.data[index].a == 1 ? true : false,
                  onChanged: (value) {
                    int active = value == true ? 1 : 0;
                    updateActivate(active, snapshot.data[index].n).then(
                      (value) {
                        utilities.setDialogeHeight();
                        setState(
                          () {},
                        );
                      },
                    );
                  },
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(64, 75, 96, .9),
        elevation: 0.1,
        title: const Text('Bible Versions'),
      ),
      body: versionsWidget(),
    );
  }
}
