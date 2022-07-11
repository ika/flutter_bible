import 'package:digitalbibleapp/cubit/book_name_cubit.dart';
import 'package:digitalbibleapp/cubit/chapters_cubit.dart';
import 'package:digitalbibleapp/cubit/version_abbr_cubit.dart';
import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/main/mainSelector.dart';
import 'package:digitalbibleapp/dialogs.dart';
import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();
Dialogs dialogs = Dialogs();

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  elevation: 8,
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: const Size(88, 36),
);

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromRGBO(64, 75, 96, .9),
      elevation: 16,
      actions: [
        Row(
          children: [
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () async {
                dialogs.versionsDialog(context);
              },
              child: BlocBuilder<VersionAbbrCubit, String>(
                builder: (context, verAbbr) {
                  return Text(
                    verAbbr,
                    style: const TextStyle(fontSize: 16),
                  );
                },
              ),
              // child: const Text(
              //   'verAbbr',
              //   style: TextStyle(fontSize: 16),
              // ),
            ),
            const SizedBox(
              width: 8,
            ),
            ElevatedButton(
              style: raisedButtonStyle,
              onPressed: () {
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  BlocBuilder<BookNameCubit, String>(
                    builder: (context, bookName) {
                      return Text(
                        bookName + ': ',
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ),
                  // const Text(
                  //   'bookName: ',
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  BlocBuilder<ChapterCubit, int>(
                    builder: (context, chapter) {
                      return Text(
                        chapter.toString(),
                        style: const TextStyle(fontSize: 16),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              // right side border width
              width: 16,
            ),
          ],
        ),
      ],
    );
  }
}
