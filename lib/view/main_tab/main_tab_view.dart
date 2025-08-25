import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/feature/cart/presentation/screens/cart_view.dart';
import 'package:lib_ms/feature/home/presentation/screens/home_view.dart';
import 'package:lib_ms/view/search/search_view.dart';
import 'package:lib_ms/view/our_books/our_books_view.dart';
import 'package:lib_ms/view/account/presentation/screens/account_view.dart';
import 'package:lib_ms/view/sell_with_us/sell_with_us_view.dart';
import 'package:lib_ms/view/newsletter/newsletter_view.dart';
import 'package:lib_ms/view/popup_leasing/popup_leasing_view.dart';
import 'package:lib_ms/common/animated_widgets.dart';

import '../../feature/wishlist/presentation/screens/wishlist_books_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});
  @override
  State<MainTabView> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MainTabView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectMenu = 0;
  int selectedTab = 0;

  final List menuArr = [
    {
      "name": "Home",
      "icon": Icons.home_rounded,
      "description": "Browse featured books and recommendations",
      "color": Colors.blue,
      "badge": null,
    },
    {
      "name": "Our Books",
      "icon": Icons.library_books_rounded,
      "description": "Explore our complete book collection",
      "color": Colors.green,
      "badge": "New",
    },
    {
      "name": "Our Stores",
      "icon": Icons.store_rounded,
      "description": "Find physical store locations",
      "color": Colors.orange,
      "badge": null,
    },
    {
      "name": "Favorite Books",
      "icon": Icons.favorite_rounded,
      "description": "Your saved and liked books",
      "color": Colors.red,
      "badge": null,
    },
    {
      "name": "Sell With Us",
      "icon": Icons.sell_rounded,
      "description": "Turn your books into cash easily",
      "color": Colors.purple,
      "badge": "💰",
    },
    {
      "name": "Newsletter",
      "icon": Icons.email_rounded,
      "description": "Stay updated with latest book news",
      "color": Colors.teal,
      "badge": "📧",
    },
    {
      "name": "Pop-up Leasing",
      "icon": Icons.storefront_rounded,
      "description": "Temporary retail space solutions",
      "color": Colors.indigo,
      "badge": "🏪",
    },
    {
      "name": "Account",
      "icon": Icons.person_rounded,
      "description": "Manage your profile and settings",
      "color": Colors.grey,
      "badge": null,
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  Widget _getSelectedPage() {
    switch (selectedTab) {
      case 0:
        return HomeView(
          key: const ValueKey('home'),
          onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        );
      case 1:
        return const SearchView(key: ValueKey('search'));
      case 2:
        return const FavoriteBooksView(key: ValueKey('wishlist'), token: '',);
      case 3:
        return CartView(key: ValueKey('Cart'));

      default:
        return HomeView(
          key: const ValueKey('home'),
          onMenuPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 10,
        width: media.width * 0.8,
        child: Container(
          decoration: BoxDecoration(
            color: Tcolor.dColor,
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(60)),
            boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 15)],
          ),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const SizedBox(height: 8),
                ...menuArr.asMap().entries.map((e) {
                  final i = e.key;
                  final m = e.value;
                  final selected = selectMenu == i;
                  return FadeInAnimation(
                    delay: Duration(milliseconds: 100 * i),
                    child: SlideInAnimation(
                      delay: Duration(milliseconds: 150 + (50 * i)),
                      begin: const Offset(1.0, 0.0),
                      child: InkWell(
                        onTap: () {
                          setState(() => selectMenu = i);
                          Navigator.of(context).pop();

                          // Handle navigation based on menu item
                          _handleMenuNavigation(i);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 12),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            gradient: selected
                                ? LinearGradient(
                                    colors: [
                                      m["color"].withOpacity(0.8),
                                      m["color"].withOpacity(0.6),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            color:
                                selected ? null : m["color"].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected
                                  ? m["color"]
                                  : m["color"].withOpacity(0.3),
                              width: selected ? 2 : 1,
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: m["color"].withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          m["name"],
                                          style: TextStyle(
                                            color: selected
                                                ? Colors.white
                                                : Tcolor.text,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          m["description"],
                                          style: TextStyle(
                                            color: selected
                                                ? Colors.white.withOpacity(0.9)
                                                : Tcolor.subTitle,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? Colors.white.withOpacity(0.2)
                                          : m["color"].withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      m["icon"],
                                      color:
                                          selected ? Colors.white : m["color"],
                                      size: 28,
                                    ),
                                  ),
                                ],
                              ),
                              if (m["badge"] != null)
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      m["badge"],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings, color: Tcolor.subTitle)),
                  TextButton(
                      onPressed: () {},
                      child: Text("Terms",
                          style: TextStyle(color: Tcolor.subTitle))),
                  const SizedBox(width: 8),
                  TextButton(
                      onPressed: () {},
                      child: Text("Privacy",
                          style: TextStyle(color: Tcolor.subTitle))),
                ]),
              ],
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.1, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              )),
              child: child,
            ),
          );
        },
        child: _getSelectedPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Tcolor.primary,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: selectedTab,
        onTap: (index) {
          setState(() {
            selectedTab = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "WishList",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Cart",
          ),
        ],
      ),
    );
  }

  void _handleMenuNavigation(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const OurBooksView(),
          ),
        );
        break;
      case 2:
        debugPrint('Navigate to Our Stores');
        break;
      case 3:
        // TODO: Navigate to Favorite Books view
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FavoriteBooksView(token: '',),
          ),
        );
        break;
      case 4: // Sell With Us
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SellWithUsView(),
          ),
        );
        break;
      case 5: // Newsletter
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewsletterView(),
          ),
        );
        break;
      case 6: // Pop-up Leasing
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PopupLeasingView(),
          ),
        );
        break;
      case 7: // Account
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AccountView(),
          ),
        );
        break;
      default:
        break;
    }
  }
}
