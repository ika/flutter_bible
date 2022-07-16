import 'package:digitalbibleapp/high/highMarksPage.dart';
import 'package:digitalbibleapp/main/mainSelector.dart';
import 'package:digitalbibleapp/notes/notes.dart';
import 'package:digitalbibleapp/vers/versionsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bmarks/bookMarksPage.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(64, 75, 96, .9),
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Bible Versions'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(
                const Duration(milliseconds: 200),
                () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const VersionsPage(),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Bookmarks'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(
                const Duration(milliseconds: 200),
                () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const BookMarksPage(),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Highlights'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(
                const Duration(milliseconds: 200),
                () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const HighLightsPage(),
                    ),
                  );
                },
              );
            },
          ),
          ListTile(
            title: const Text('Book Selection'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(
                const Duration(milliseconds: 200),
                () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const MainSelector(),
                    ),
                  );
                },
              );
            },
          ),
                    ListTile(
            title: const Text('Notes'),
            onTap: () {
              Navigator.pop(context);
              Future.delayed(
                const Duration(milliseconds: 200),
                () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const NotesPage(),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
