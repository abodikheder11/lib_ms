// cart_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/data/models/book_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());

  final List<Book> _cart = [];

  void addToCart(Book book) {
    _cart.add(book);
    emit(CartUpdated(List.from(_cart))); 
  }

  void removeFromCart(Book book) {
    _cart.remove(book);
    emit(CartUpdated(List.from(_cart)));
  }

  void clearCart() {
    _cart.clear();
    emit(CartUpdated(List.from(_cart)));
  }

  List<Book> get cartItems => List.unmodifiable(_cart);
}
