import 'package:digitalbibleapp/cubit/version_abbr_cubit.dart';
import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/main/mainAppBarVersion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Dialogs {

  List<String> contextMenu = ['Compare', 'Bookmanr', 'Hilight'];

  Future<dynamic> contextDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          //title: const Text("Select Value"),
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: contextMenu.length,
                    itemBuilder: (context, index) {
                      //return optionOne;
                      return SimpleDialogOption(
                        //onPressed: () => Navigator.pop(context),
                        child: Text(contextMenu[index]),
                        onPressed: () {
                          Navigator.pop(context);
                          print('pressed ' + contextMenu[index]);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> versionsDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return SimpleDialog(
          children: [
            SizedBox(
              height: Globals.dialogHeight,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlocProvider<VersionAbbrCubit>(
                      create: (context) => VersionAbbrCubit(),
                      child: const AppBarVersions(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
