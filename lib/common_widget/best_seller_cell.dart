import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lib_ms/common/color__extention.dart';

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
            onTap: () async {
              try {
                final repo = BookRepository();
                final file = await repo.downloadBook(
                  b0bj["id"],
                  "${b0bj["name"]}.pdf",
                );

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Downloaded to: ${file.path}")),
                  );
                }



              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Download failed: $e")),
                  );
                  print(e);
                }
              }
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
