import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class BookVersionCubit extends Cubit<int> {

  final _sharedPrefs = SharedPrefs();
  
  BookVersionCubit() : super(1);

  void setVersion(int v) => emit(v);

  void getVersion() async => emit(await _sharedPrefs.readVersion());
}
