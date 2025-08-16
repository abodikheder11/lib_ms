import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';

class TopPicksCell extends StatelessWidget {
  final Map i0bj;
  const TopPicksCell({super.key, required this.i0bj});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
        width: media.width * 0.32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
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
                  i0bj["img"].toString(),
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
