// cart_state.dart
import 'package:equatable/equatable.dart';

import '../../../home/data/models/book_model.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final List<Book> cartItems;

  const CartUpdated(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}
