import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/data/repository/book_repository.dart';
import 'wishlist_book_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final BookRepository repo;
  FavoriteCubit(this.repo) : super(FavoriteInitial());


  Future<void> loadFavorites() async {
    emit(FavoriteLoading());
    try {
      final books = await repo.getFavoriteBooks();
      emit(FavoriteLoaded(books));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> addBookToFavorite(int bookId) async {
    try {
      await repo.addToFavorite(bookId);
      loadFavorites();
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}
