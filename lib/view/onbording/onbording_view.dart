import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/view/onbording/welcome_view.dart';
import 'package:lib_ms/common/page_transitions.dart';

class OnbordingView extends StatefulWidget {
  const OnbordingView({super.key});

  @override
  State<OnbordingView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<OnbordingView> {
  int page = 0;
  PageController? controller = PageController();
  List pageArr = [
    {
      "title": "Discounted\nSecond Book",
      "sub_title": "used and near new secondhand books at great prices",
      "img": "assets/images/0.jpg"
    },
    {
      "title": "20 Book Grocers Nationally",
      "sub_title": "We've saccessfully opened 20 stores across Austalia ",
      "img": "assets/images/0.jpg"
    },
    {
      "title": "Sell Or Recycle Your Old\nBooks With Us",
      "sub_title":
          "You are looking to downsize,sell or recycle old books , the book grocer can help",
      "img": "assets/images/0.jpg"
    },
  ];
  @override
  void initState() {
    super.initState();
    controller?.addListener(() {
      page = controller?.page?.round() ?? 0;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: controller,
              itemCount: pageArr.length,
              itemBuilder: (context, index) {
                var pObj = pageArr[index] as Map? ?? {};
                return Container(
                  width: media.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                  child: Column(
                    children: [
                      Text(
                        pObj["title"].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Tcolor.primary,
                            fontSize: 30,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //////////////
                      Text(
                        pObj["sub_title"].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Tcolor.primaryLight,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: media.width * 0.25,
                      ),
                      Image.asset(
                        pObj["img"].toString(),
                        width: media.width * 0.8,
                        height: media.width * 0.8,
                        fit: BoxFit.fitHeight,
                      ),
                    ],
                  ),
                );
              },
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushSlide(
                            const WelcomeView(),
                            direction: SlideDirection.rightToLeft,
                          );
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: Tcolor.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: pageArr.map((pObj) {
                          var index = pageArr.indexOf(pObj);
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: page == index ? 20 : 15,
                            height: 15,
                            decoration: BoxDecoration(
                                color: page == index
                                    ? Tcolor.primary
                                    : Tcolor.primaryLight,
                                borderRadius: BorderRadius.circular(5)),
                          );
                        }).toList(),
                      ),
                      TextButton(
                        onPressed: () {
                          if (page < 2) {
                            page = page + 1;
                            controller?.animateToPage(
                              page,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            Navigator.of(context).pushSlide(
                              const WelcomeView(),
                              direction: SlideDirection.rightToLeft,
                            );
                          }
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(
                            color: Tcolor.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.15,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
