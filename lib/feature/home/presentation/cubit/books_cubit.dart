import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/book_repository.dart';
import 'books_state.dart';

class BookCubit extends Cubit<BookState> {
  final BookRepository repository;
  BookCubit(this.repository) : super(BookInitial());

  Future<void> fetchBooks() async {
    emit(BookLoading());
    try {
      final books = await repository.fetchBooks();
      emit(BookLoaded(books));
    } catch (e) {
      emit(BookError(e.toString()));
    }
  }
}