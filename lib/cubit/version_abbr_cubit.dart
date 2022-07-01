import 'package:digitalbibleapp/utils/sharedPrefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VersionAbbrCubit extends Cubit<String> {
  final _sharedPrefs = SharedPrefs();
  VersionAbbrCubit() : super('');

  void setVersionAbbr(String r) async => emit(r);
  
  void getVersionAbbr() async => emit(await _sharedPrefs.readVerAbbr());
}
