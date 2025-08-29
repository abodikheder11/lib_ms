import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_ms/common/color__extention.dart';

import '../feature/cart/presentation/bloc/cart_cubit.dart';
import '../feature/home/data/models/book_model.dart';

class TopPicksCell extends StatelessWidget {
  final Map i0bj;
  const TopPicksCell({super.key, required this.i0bj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return SizedBox(
        width: media.width * 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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
                    width: media.width * 0.4,
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
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Tcolor.text,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              i0bj["authar"].toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Tcolor.subTitle,
                fontSize: 11,
              ),
            )
          ],
        ));
  }
}

const String bookExcerpt1 =
    "It is a truth universally acknowledged, that a single man in possession of a good fortune, "
    "must be in want of a wife. However little known the feelings or views of such a man may be "
    "on his first entering a neighbourhood, this truth is so well fixed in the minds of the "
    "surrounding families, that he is considered the rightful property of some one or other "
    "of their daughters.\n\n"
    "“My dear Mr. Bennet,” said his lady to him one day, “have you heard that Netherfield Park "
    "is let at last?”\n\n"
    "Mr. Bennet replied that he had not. But it is, returned she; “for Mrs. Long has just been "
    "here, and she told me all about it.” Mr. Bennet made no answer. “Do you not want to know "
    "who has taken it?” cried his wife impatiently. “You want to tell me, and I have no "
    "objection to hearing it.” This was invitation enough.\n\n"
    "“Why, my dear, you must know, Mrs. Long says that Netherfield is taken by a young man of "
    "large fortune from the north of England; that he came down on Monday in a chaise and four "
    "to see the place, and was so much delighted with it that he agreed with Mr. Morris "
    "immediately; that he is to take possession before Michaelmas, and some of his servants "
    "are to be in the house by the end of next week.”";
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
                    bookExcerpt1,
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
                        title: book["title"]?.toString() ?? "My Book!",
                        description: book["description"]?.toString() ?? "great",
                        price: double.tryParse(book["price"].toString()) ?? 4.2,
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
