import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lib_ms/common/color__extention.dart';

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black38,
                        offset: Offset(0, 2),
                        blurRadius: 3)
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  b0bj["img"].toString(),
                  width: media.width * 0.32,
                  height: media.width * 0.50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              b0bj["name"].toString(),
              maxLines: 3,
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Tcolor.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              b0bj["authar"].toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Tcolor.subTitle,
                fontSize: 11,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            IgnorePointer(
              ignoring: true,
              child: RatingBar.builder(
                initialRating: double.tryParse(
                      b0bj["rating"].toString(),
                    ) ??
                    1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 15,
                itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Tcolor.primary),
                onRatingUpdate: (rating) {
                  // Handle rating update
                },
              ),
            ),
          ],
        ));
  }
}
