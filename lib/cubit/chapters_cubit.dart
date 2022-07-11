import 'package:digitalbibleapp/globals.dart';
import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChapterCubit extends Cubit<int> {
  final _sharedPrefs = SharedPrefs();

  ChapterCubit() : super(1);

  void setChapter(int c) => emit(c);

  void getChapter() async {
    Globals.bookChapter = await _sharedPrefs.readChapter();
    emit(Globals.bookChapter);
  }
}
