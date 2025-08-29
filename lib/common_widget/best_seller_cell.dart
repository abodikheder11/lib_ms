import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lib_ms/common/color__extention.dart';

import '../feature/cart/presentation/bloc/cart_cubit.dart';
import '../feature/home/data/models/book_model.dart';
import '../feature/home/data/repository/book_repository.dart';

class BestSellerCell extends StatelessWidget {
  final Map b0bj;
  const BestSellerCell({super.key, required this.b0bj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      width: media.width * 0.32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _showBookBrief(context, b0bj);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 2),
                      blurRadius: 3)
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  b0bj["img"].toString(),
                  width: media.width * 0.32,
                  height: media.width * 0.50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),
          Text(
            b0bj["name"].toString(),
            maxLines: 3,
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            b0bj["authar"].toString(),
            style: TextStyle(
              color: Tcolor.subTitle,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          IgnorePointer(
            ignoring: true,
            child: RatingBar.builder(
              initialRating: double.tryParse(b0bj["rating"].toString()) ?? 1,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 15,
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: Tcolor.primary),
              onRatingUpdate: (_) {},
            ),
          ),
        ],
      ),
    );
  }
}
const String bookExcerpt2 =
    "Call me Ishmael. Some years ago—never mind how long precisely—having little or no money "
    "in my purse, and nothing particular to interest me on shore, I thought I would sail about "
    "a little and see the watery part of the world. It is a way I have of driving off the spleen, "
    "and regulating the circulation. Whenever I find myself growing grim about the mouth; whenever "
    "it is a damp, drizzly November in my soul; whenever I find myself involuntarily pausing before "
    "coffin warehouses, and bringing up the rear of every funeral I meet; and especially whenever "
    "my hypos get such an upper hand of me, that it requires a strong moral principle to prevent me "
    "from deliberately stepping into the street, and methodically knocking people’s hats off—then, "
    "I account it high time to get to sea as soon as I can.\n\n"
    "There is nothing surprising in this. If they but knew it, almost all men in their degree, "
    "some time or other, cherish very nearly the same feelings towards the ocean with me.\n\n"
    "There now is your insular city of the Manhattoes, belted round by wharves as Indian isles by "
    "coral reefs—commerce surrounds it with her surf. Right and left, the streets take you waterward. "
    "Its extreme downtown is the battery, where that noble mole is washed by waves, and cooled by breezes, "
    "which a few hours previous were out of sight of land. Look at the crowds of water-gazers there.";

void _showBookBrief(BuildContext context, Map book) {
  showDialog(
    context: context,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 500,
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book["name"].toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "by ${book["authar"]}",
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              const Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    bookExcerpt2,
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {

                      final bookModel = Book(
                        id: int.tryParse(book["id"].toString()) ?? 0,
                        title: book["title"]?.toString() ?? "book",
                        description: book["description"]?.toString() ?? "great",
                        price: double.tryParse(book["price"].toString()) ?? 0.0,
                        imagePath: book["image"]?.toString() ?? "",
                      );

                      context.read<CartCubit>().addToCart(bookModel);

                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${book["name"]} added to cart")),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Add to Cart"),
                  ),

                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
