import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookNameCubit extends Cubit<String> {
  final _sharedPrefs = SharedPrefs();

  BookNameCubit() : super('John');

  void setBookName(String n) => emit(n);

  void getBookName() async => emit(await _sharedPrefs.readBookName());
}
