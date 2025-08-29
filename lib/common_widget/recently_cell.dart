import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_ms/common/color__extention.dart';

import '../feature/cart/presentation/bloc/cart_cubit.dart';
import '../feature/home/data/models/book_model.dart';

class RecentlyCell extends StatelessWidget {
  final Map i0bj;
  const RecentlyCell({super.key, required this.i0bj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        width: media.width * 0.32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                _showBookBrief(context, i0bj);
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
                    i0bj["img"].toString(),
                    width: media.width * 0.32,
                    height: media.width * 0.60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              i0bj["name"].toString(),
              maxLines: 3,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Tcolor.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              i0bj["authar"].toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Tcolor.subTitle,
                fontSize: 11,
              ),
            )
          ],
        ));
  }
}

const String bookExcerpt3 =
    "Alice was beginning to get very tired of sitting by her sister on the bank, and of having nothing to do: "
    "once or twice she had peeped into the book her sister was reading, but it had no pictures or conversations in it, "
    "‘and what is the use of a book,’ thought Alice ‘without pictures or conversation?’\n\n"
    "So she was considering in her own mind (as well as she could, for the hot day made her feel very sleepy and stupid), "
    "whether the pleasure of making a daisy-chain would be worth the trouble of getting up and picking the daisies, when "
    "suddenly a White Rabbit with pink eyes ran close by her.\n\n"
    "There was nothing so very remarkable in that; nor did Alice think it so very much out of the way to hear the Rabbit "
    "say to itself, ‘Oh dear! Oh dear! I shall be late!’ (when she thought it over afterwards, it occurred to her that she "
    "ought to have wondered at this, but at the time it all seemed quite natural); but when the Rabbit actually took a watch "
    "out of its waistcoat-pocket, and looked at it, and then hurried on, Alice started to her feet, for it flashed across her "
    "mind that she had never before seen a rabbit with either a waistcoat-pocket, or a watch to take out of it, and burning "
    "with curiosity, she ran across the field after it, and fortunately was just in time to see it pop down a large rabbit-hole "
    "under the hedge.";
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
                    bookExcerpt3,
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
