import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/vers/vkModel.dart';
import 'package:digitalbibleapp/main/mainPage.dart';
import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:digitalbibleapp/vers/vkQueries.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

VkQueries _vkQueries = VkQueries(); // version key
SharedPrefs sharedPrefs = SharedPrefs();

class AppBarVersions extends StatelessWidget {
  const AppBarVersions({Key key}) : super(key: key);

  Future<String> readVersionKey(int v) async {
    List<VkModel> value = List<VkModel>.empty();
    value = await _vkQueries.getVersionKey(v);
    String r = value.first.r; // abbreviation
    return r;
  }

  Future<String> readVersionAbbr(int v) async {
    String verKeys = await readVersionKey(v);
    var vKeys = verKeys.split('|');
    String r = vKeys[0];
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VkModel>>(
      future: _vkQueries.getActiveVersions(),
      builder: (context, AsyncSnapshot<List<VkModel>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.isEmpty) {
            return const SizedBox(
              height: 100.0,
              child: Text(
                  'You need to activate at least one Bible version to use this feature.'),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                return GestureDetector(
                  onTap: () {
                    //Navigator.pop(context, false);
                    int v = snapshot.data[index].n;
                    Globals.bibleVersion = v;
                    sharedPrefs.saveVersion(v).then(
                      (value) async {
                        readVersionAbbr(v).then(
                          (r) {
                            sharedPrefs.saveVerAbbr(r);

                            //print('AppBarVersions ver $v verAbbr $r');
                          },
                        );
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
                      },
                    );
                  },
                  child: SizedBox(
                    height: 32,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.data[index].m,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 16.0,
                            fontStyle: FontStyle.normal,
                            color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
