import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lib_ms/common_widget/best_seller_cell.dart';
import 'package:lib_ms/common_widget/recently_cell.dart';
import 'package:lib_ms/common_widget/top_picks_cell.dart';
import 'package:lib_ms/common/animated_widgets.dart';

import '../cubit/books_cubit.dart';
import '../cubit/books_state.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onMenuPressed;
  const HomeView({super.key, this.onMenuPressed});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController txtName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery
        .of(context)
        .size;

    return BlocBuilder<BookCubit, BookState>(
      builder: (context, state) {
        if (state is BookLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is BookLoaded) {
          final books = state.books;

          final topPicksArr = books.take(3).toList();
          final bestArr = books.skip(3).take(3).toList();
          final recentArr = books.reversed.take(3).toList();

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
                              BorderRadius.circular(media.width * 0.5),
                            ),
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
                                  child: Text(
                                    "Our Top Picks",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.menu,
                                      color: Colors.black87),
                                  onPressed: widget.onMenuPressed ??
                                          () {
                                        Scaffold.maybeOf(context)
                                            ?.openEndDrawer();
                                      },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: media.width * 0.1),
                          // Carousel
                          FadeInAnimation(
                            delay: const Duration(milliseconds: 600),
                            child: SizedBox(
                              width: media.width,
                              height: media.width * 0.8,
                              child: CarouselSlider.builder(
                                itemCount: topPicksArr.length,
                                itemBuilder: (context, index, _) {
                                  final book = topPicksArr[index];
                                  return TopPicksCell(i0bj: {
                                    "name": book.title,
                                    "authar": book.author?.firstname ?? "Unknown",
                                    "img": book.imagePath ?? "",
                                  });
                                },
                                options: CarouselOptions(
                                  autoPlay: false,
                                  aspectRatio: 1,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.45,
                                  enlargeFactor: 0.4,
                                  enlargeStrategy:
                                  CenterPageEnlargeStrategy.zoom,
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
                                    fontWeight: FontWeight.w700,
                                  ),
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
                              itemBuilder: (context, index) {
                                final book = bestArr[index];
                                return BestSellerCell(b0bj: {
                                  "id" : book.id,
                                  "name": book.title,
                                  "authar":
                                  "by ${book.author?.firstname ?? 'Unknown'}",
                                  "img": book.imagePath ?? "",
                                  "rating": (3 + Random().nextDouble() * 2).toStringAsFixed(1), // 3.0 → 5.0
                                });
                              },
                            ),
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
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(
                          //   height: media.width * 0.6,
                          //   child: ListView.builder(
                          //     padding: const EdgeInsets.symmetric(
                          //         horizontal: 8, vertical: 15),
                          //     scrollDirection: Axis.horizontal,
                          //     itemCount: genresArr.length,
                          //     itemBuilder: (context, index) {
                          //       var b0bj = genresArr[index] as Map? ?? {};
                          //       return GenresCell(
                          //         b0bj: b0bj,
                          //         bgcolor: index % 2 == 0
                          //             ? Tcolor.color1
                          //             : Tcolor.color2,
                          //       );
                          //     },
                          //   ),
                          // ),
                          SizedBox(height: media.width * 0.1),
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
                                    fontWeight: FontWeight.w700,
                                  ),
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
                              itemBuilder: (context, index) {
                                final book = recentArr[index];
                                return RecentlyCell(i0bj: {
                                  "name": book.title,
                                  "authar":
                                  "by ${book.author?.firstname ?? 'Unknown'}",
                                  "img": book.imagePath ?? "",
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is BookError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }
}