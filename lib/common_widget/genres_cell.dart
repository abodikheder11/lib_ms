import 'package:flutter/material.dart';

class GenresCell extends StatelessWidget {
  final Map b0bj;
  final Color bgcolor;
  const GenresCell({super.key, required this.b0bj, required this.bgcolor});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: bgcolor, borderRadius: BorderRadius.circular(15)),
        width: media.width * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              b0bj["img"].toString(),
              width: media.width * 0.7,
              height: media.width * 0.35,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              b0bj["name"].toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ));
  }
}
