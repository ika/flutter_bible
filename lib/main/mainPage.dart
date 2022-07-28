import 'package:digitalbibleapp/cubit/bible_version_cubit.dart';
import 'package:digitalbibleapp/cubit/book_name_cubit.dart';
import 'package:digitalbibleapp/cubit/chapters_cubit.dart';
import 'package:digitalbibleapp/cubit/version_abbr_cubit.dart';
import 'package:digitalbibleapp/main/mainAppBar.dart';
import 'package:digitalbibleapp/main/mainChapters.dart';
import 'package:digitalbibleapp/main/mainDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: MainDrawer(),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: MainAppBar(),
      ),
      body: MainChapters(),
    );
  }
}

class MainPageCall extends StatelessWidget {
  const MainPageCall({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BookVersionCubit>(
            create: (context) => BookVersionCubit()..getVersion(),
          ),
          BlocProvider<ChapterCubit>(
            create: (context) => ChapterCubit()..getChapter(),
          ),
          BlocProvider<BookNameCubit>(
            create: (context) => BookNameCubit()..getBookName(),
          ),
          BlocProvider<VersionAbbrCubit>(
            create: (context) => VersionAbbrCubit()..getVersionAbbr(),
          ),
        ],
        child: const MainPage(),
      ),
    );
  }
}
