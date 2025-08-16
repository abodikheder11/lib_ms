import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lib_ms/common_widget/best_seller_cell.dart';
import 'package:lib_ms/common_widget/genres_cell.dart';
import 'package:lib_ms/common_widget/recently_cell.dart';
import 'package:lib_ms/common_widget/top_picks_cell.dart';
import 'package:lib_ms/common/animated_widgets.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onMenuPressed;
  const HomeView({super.key, this.onMenuPressed});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  List topPicksArr = [
    {
      "name": "The Dissapearance of Emila zola",
      "authar": "Michael Rosen",
      "img": "assets/images/111.jpg"
    },
    {
      "name": "Fatherhood",
      "authar": "Marcus breakmann",
      "img": "assets/images/222.jpg"
    },
    {
      "name": "The time Travellers Handbook",
      "authar": "Straide lottie",
      "img": "assets/images/333.jpg"
    }
  ];
  List bestArr = [
    {
      "name": "Fatherhood",
      "authar": "by Christopher Wilson",
      "img": "assets/images/44.jpg",
      "rating": 5.0
    },
    {
      "name": "In A Land Of Paper Gods",
      "authar": "by Rebecca Mackenzie",
      "img": "assets/images/66.jpg",
      "rating": 4.0
    },
    {
      "name": "The Tattletale ",
      "authar": "by Sara J.Noughton",
      "img": "assets/images/55.jpg",
      "rating": 3.0
    }
  ];
  List genresArr = [
    {
      "name": "Graphic Novels",
      "img": "assets/images/7.png",
    },
    {
      "name": "Graphic Novels",
      "img": "assets/images/8.png",
    },
    {
      "name": "Graphic Novels",
      "img": "assets/images/9.png",
    }
  ];

  List recentArr = [
    {
      "name": "The Fatal Tree",
      "authar": "by jake arnott",
      "img": "assets/images/10.jpg"
    },
    {
      "name": "Day Four",
      "authar": "by lotz,sarah",
      "img": "assets/images/11.jpg"
    },
    {
      "name": "Door To Door",
      "authar": "by eward humes",
      "img": "assets/images/12.jpg"
    }
  ];
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Align(
                  child: Transform.scale(
                    scale: 1.5,
                    origin: Offset(0, media.width * 0.8),
                    child: Container(
                      width: media.width,
                      height: media.width,
                      decoration: BoxDecoration(
                          color: Tcolor.primary,
                          borderRadius:
                              BorderRadius.circular(media.width * 0.5)),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: media.width * 0.1),
                    // عنوان أعلى مع أيقونة الـ menu على اليمين تفتح endDrawer
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        children: [
                          const Expanded(
                              child: Text("Our Top Picks",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700))),
                          IconButton(
                            icon: const Icon(Icons.menu, color: Colors.black87),
                            onPressed: widget.onMenuPressed ??
                                () {
                                  // يفتح الـ endDrawer الموجود في الـ Scaffold الأب
                                  Scaffold.maybeOf(context)?.openEndDrawer();
                                },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: media.width * 0.1),
                    // Carousel و بقية المحتوى كما في كودك الأصلي...
                    FadeInAnimation(
                      delay: const Duration(milliseconds: 600),
                      child: SizedBox(
                        width: media.width,
                        height: media.width * 0.8,
                        child: CarouselSlider.builder(
                          itemCount: topPicksArr.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) {
                            var i0bj = topPicksArr[itemIndex] as Map? ?? {};
                            return ScaleInAnimation(
                              delay: Duration(
                                  milliseconds: 800 + (itemIndex * 200)),
                              child: TopPicksCell(i0bj: i0bj),
                            );
                          },
                          options: CarouselOptions(
                            autoPlay: false,
                            aspectRatio: 1,
                            enlargeCenterPage: true,
                            viewportFraction: 0.45,
                            enlargeFactor: 0.4,
                            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                          ),
                        ),
                      ),
                    ),
                    ////////////////////////////
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Bestsellers",
                            style: TextStyle(
                                color: Tcolor.text,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.9,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 15),
                          scrollDirection: Axis.horizontal,
                          itemCount: bestArr.length,
                          itemBuilder: ((context, index) {
                            var b0bj = bestArr[index] as Map? ?? {};

                            return BestSellerCell(
                              b0bj: b0bj,
                            );
                          })),
                    ),
                    //////////////////////////////////
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Genres",
                            style: TextStyle(
                                color: Tcolor.text,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.6,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 15),
                          scrollDirection: Axis.horizontal,
                          itemCount: genresArr.length,
                          itemBuilder: ((context, index) {
                            var b0bj = genresArr[index] as Map? ?? {};

                            return GenresCell(
                              b0bj: b0bj,
                              bgcolor: index % 2 == 0
                                  ? Tcolor.color1
                                  : Tcolor.color2,
                            );
                          })),
                    ),
                    SizedBox(
                      height: media.width * 0.1,
                    ),
                    ///////////////////////////////
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Text(
                            "Recently viewed",
                            style: TextStyle(
                                color: Tcolor.text,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width,
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 15),
                          scrollDirection: Axis.horizontal,
                          itemCount: recentArr.length,
                          itemBuilder: ((context, index) {
                            var b0bj = recentArr[index] as Map? ?? {};

                            return RecentlyCell(
                              i0bj: b0bj,
                            );
                          })),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
