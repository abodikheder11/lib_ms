
import '../../../home/data/models/book_model.dart';

abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}
class FavoriteLoading extends FavoriteState {}
class FavoriteLoaded extends FavoriteState {
  final List<Book> books;
  FavoriteLoaded(this.books);
}
class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
}
