import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common/color__extention.dart';
import '../../../home/data/repository/book_repository.dart';
import '../bloc/wishlist_book_cubit.dart';
import '../bloc/wishlist_book_state.dart';

class FavoriteBooksView extends StatelessWidget {
  final String token;
  const FavoriteBooksView({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FavoriteCubit(BookRepository())..loadFavorites(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Favorites"),
          backgroundColor: Tcolor.primary,
        ),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FavoriteLoaded) {
              if (state.books.isEmpty) {
                return const Center(child: Text("No favorite books yet."));
              }
              return ListView.builder(
                itemCount: state.books.length,
                itemBuilder: (_, i) {
                  final book = state.books[i];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: (book.imagePath != null && book.imagePath!.isNotEmpty)
                          ? Image.network(
                        book.imagePath!,
                        width: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.book),
                      )
                          : const Icon(Icons.book),
                      title: Text(book.title),
                      // subtitle: Text(book),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          context.read<FavoriteCubit>().addBookToFavorite(book.id);
                        },
                      ),
                    ),
                  );
                },
              );
            } else if (state is FavoriteError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
