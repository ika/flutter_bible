import 'package:digitalbibleapp/cubit/book_name_cubit.dart';
import 'package:digitalbibleapp/cubit/chapters_cubit.dart';
import 'package:digitalbibleapp/cubit/version_abbr_cubit.dart';
import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/main/mainAppBarVersion.dart';
import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

SharedPrefs sharedPrefs = SharedPrefs();

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  elevation: 8,
  onPrimary: Colors.black87,
  primary: Colors.grey[300],
  minimumSize: const Size(88, 36),
);

class MainAppBar extends StatelessWidget {
  const MainAppBar({Key key}) : super(key: key);

  Future<dynamic> versionDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: Globals.dialogHeight,
            width: double.maxFinite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expanded(
                //   child: AppBarVersions(),
                // ),
                Expanded(
                  child: BlocProvider<VersionAbbrCubit>(
                    create: (context) => VersionAbbrCubit(),
                    child: const AppBarVersions(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                versionDialog(context);
                // Future.delayed(
                //   const Duration(milliseconds: 200),
                //   () {
                //     Navigator.push(
                //       context,
                //       CupertinoPageRoute(
                //         builder: (context) => const MainVersionsPage(),
                //       ),
                //     );
                //   },
                // );
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
                print('Bookname - finish me');
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
