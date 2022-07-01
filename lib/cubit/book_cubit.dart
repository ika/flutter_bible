import 'package:flutter_bloc/flutter_bloc.dart';

class BookState {
  int book; // book number
  BookState({this.book});
}

class BookCubit extends Cubit<BookState> {
  BookCubit() : super(BookState(book: 43));

  void set(int b) {
    emit(BookState(book: state.book = b));
  }
}
