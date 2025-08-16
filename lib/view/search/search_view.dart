import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/common/extention.dart';
import 'package:lib_ms/common_widget/history_row.dart';
import 'package:lib_ms/common_widget/search_grid_cell.dart';
import 'package:lib_ms/view/search/search_force_view.dart';
import 'package:lib_ms/common/page_transitions.dart';
import 'package:lib_ms/common/animated_widgets.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> with TickerProviderStateMixin {
  TextEditingController txtSearch = TextEditingController();
  int selectTag = 0;
  late AnimationController _searchAnimationController;
  late Animation<double> _searchScaleAnimation;
  bool _isSearchFocused = false;
  List<Map<String, dynamic>> _filteredResults = [];
  Timer? _searchDebounceTimer;
  bool _isSearching = false;
  final List<String> tagsArr = [
    "Genre",
    "New Release",
    "The Art",
    "Genre1",
    "New Release1",
    "The Art1",
  ];
  final List<Map<String, dynamic>> searchArr = [
    {
      "name": "Biography",
      "img": "assets/images/13.jpg",
    },
    {
      "name": "Business",
      "img": "assets/images/17.jpg",
    },
    {
      "name": "Children",
      "img": "assets/images/16.jpg",
    },
    {
      "name": "Cookery",
      "img": "assets/images/14.png",
    },
    {
      "name": "Fiction",
      "img": "assets/images/15.jpg",
    },
    {
      "name": "Graphic Novels",
      "img": "assets/images/18.jpg",
    }
  ];
  List<Map<String, dynamic>> allBooksDatabase = [
    {
      "name": "The Heart Of Hell",
      "img": "assets/images/s1.jpg",
      "auther": "Mitch Weiss",
      "description":
          "The untold story of courage and sacrifice in the shadow of Iwo Jima",
      "rate": 5.0,
      "category": "History",
      "keywords": ["war", "history", "courage", "sacrifice", "iwo jima"]
    },
    {
      "name": "Ardennes 1944",
      "img": "assets/images/s2.jpg",
      "auther": "Antony Beevor",
      "description":
          "International bestseller and award winning history book about WWII",
      "rate": 4.0,
      "category": "History",
      "keywords": ["war", "history", "wwii", "battle", "ardennes"]
    },
    {
      "name": "War In The Gothic Line",
      "img": "assets/images/s3.jpg",
      "auther": "Christian Jennings",
      "description":
          "Through the eyes of thirteen men & women from seven different nations",
      "rate": 3.0,
      "category": "History",
      "keywords": ["war", "gothic line", "nations", "perspective"]
    },
    {
      "name": "Digital Minimalism",
      "img": "assets/images/10.jpg",
      "auther": "Cal Newport",
      "description": "A philosophy for living better with less technology",
      "rate": 4.5,
      "category": "Self-Help",
      "keywords": [
        "technology",
        "minimalism",
        "digital",
        "philosophy",
        "lifestyle"
      ]
    },
    {
      "name": "The Art of Living",
      "img": "assets/images/11.jpg",
      "auther": "Thich Nhat Hanh",
      "description":
          "A guide to mindfulness and meditation for peaceful living",
      "rate": 4.3,
      "category": "Spirituality",
      "keywords": ["mindfulness", "meditation", "peace", "buddhism", "zen"]
    },
    {
      "name": "Business Strategy",
      "img": "assets/images/12.jpg",
      "auther": "Michael Porter",
      "description": "Essential business strategies for modern entrepreneurs",
      "rate": 4.2,
      "category": "Business",
      "keywords": [
        "business",
        "strategy",
        "entrepreneur",
        "management",
        "success"
      ]
    },
    {
      "name": "Biography Collection",
      "img": "assets/images/13.jpg",
      "auther": "Various Authors",
      "description":
          "Inspiring biographies of influential figures throughout history",
      "rate": 4.4,
      "category": "Biography",
      "keywords": [
        "biography",
        "history",
        "influential",
        "leaders",
        "inspiration"
      ]
    },
    {
      "name": "Culinary Adventures",
      "img": "assets/images/14.png",
      "auther": "Gordon Ramsay",
      "description":
          "Exciting recipes and culinary techniques from around the world",
      "rate": 4.7,
      "category": "Cooking",
      "keywords": [
        "cooking",
        "recipes",
        "culinary",
        "food",
        "chef",
        "gordon ramsay"
      ]
    },
    {
      "name": "Fiction Masterpiece",
      "img": "assets/images/15.jpg",
      "auther": "Margaret Atwood",
      "description":
          "A thought-provoking work exploring themes of identity and society",
      "rate": 4.6,
      "category": "Fiction",
      "keywords": ["fiction", "identity", "society", "literary", "contemporary"]
    },
    {
      "name": "Children's Wonder",
      "img": "assets/images/16.jpg",
      "auther": "Roald Dahl",
      "description":
          "A delightful children's book filled with imagination and adventure",
      "rate": 4.8,
      "category": "Children",
      "keywords": [
        "children",
        "adventure",
        "imagination",
        "roald dahl",
        "fantasy"
      ]
    },
    {
      "name": "Modern Romance",
      "img": "assets/images/17.jpg",
      "auther": "Aziz Ansari",
      "description":
          "A hilarious look at modern dating culture and relationships",
      "rate": 4.1,
      "category": "Romance",
      "keywords": ["romance", "dating", "relationships", "modern", "comedy"]
    },
    {
      "name": "Graphic Novel Epic",
      "img": "assets/images/18.jpg",
      "auther": "Neil Gaiman",
      "description":
          "A stunning graphic novel combining beautiful art with compelling story",
      "rate": 4.9,
      "category": "Graphic Novel",
      "keywords": ["graphic novel", "art", "fantasy", "neil gaiman", "visual"]
    }
  ];

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _searchScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _searchAnimationController,
      curve: Curves.easeInOut,
    ));

    // Initialize filtered results with all books
    _filteredResults = List.from(allBooksDatabase);

    // Add listener to search controller for real-time search with debouncing
    txtSearch.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _searchAnimationController.dispose();
    _searchDebounceTimer?.cancel();
    txtSearch.dispose();
    super.dispose();
  }

  void _onSearchTextChanged() {
    // Cancel previous timer
    _searchDebounceTimer?.cancel();

    // Show loading state immediately for very responsive feedback
    setState(() {
      _isSearching = true;
    });

    // Start new timer for debounced search
    _searchDebounceTimer = Timer(const Duration(milliseconds: 200), () {
      _performSearch();
    });
  }

  void _onSearchTap() {
    setState(() {
      _isSearchFocused = true;
    });
    _searchAnimationController.forward();
  }

  void _onSearchComplete() {
    setState(() {
      _isSearchFocused = false;
    });
    _searchAnimationController.reverse();
  }

  void _performSearch() {
    final query = txtSearch.text.toLowerCase().trim();

    setState(() {
      _isSearching = false; // Clear loading state

      if (query.isEmpty) {
        _filteredResults = List.from(allBooksDatabase);
        return;
      }

      // Enhanced search with scoring system
      List<MapEntry<Map<String, dynamic>, double>> scoredResults = [];

      for (var book in allBooksDatabase) {
        double score = _calculateSearchScore(book, query);
        if (score > 0) {
          scoredResults.add(MapEntry(book, score));
        }
      }

      // Sort by score (highest first)
      scoredResults.sort((a, b) => b.value.compareTo(a.value));

      // Extract the books from scored results
      _filteredResults = scoredResults.map((entry) => entry.key).toList();
    });
  }

  double _calculateSearchScore(Map<String, dynamic> book, String query) {
    double score = 0.0;

    final bookName = book['name']?.toString().toLowerCase() ?? '';
    final authorName = book['auther']?.toString().toLowerCase() ?? '';
    final description = book['description']?.toString().toLowerCase() ?? '';
    final category = book['category']?.toString().toLowerCase() ?? '';
    final keywords = book['keywords'] as List<dynamic>? ?? [];

    // Exact matches get highest scores
    if (bookName == query) score += 100.0;
    if (authorName == query) score += 90.0;
    if (category == query) score += 80.0;

    // Starts with query gets high scores
    if (bookName.startsWith(query)) score += 70.0;
    if (authorName.startsWith(query)) score += 60.0;

    // Contains query gets medium scores
    if (bookName.contains(query)) score += 50.0;
    if (authorName.contains(query)) score += 40.0;
    if (category.contains(query)) score += 30.0;
    if (description.contains(query)) score += 20.0;

    // Keyword matches
    for (String keyword in keywords) {
      final keywordLower = keyword.toLowerCase();
      if (keywordLower == query) score += 35.0;
      if (keywordLower.startsWith(query)) score += 25.0;
      if (keywordLower.contains(query)) score += 15.0;
    }

    // Letter-by-letter matching for very sensitive search
    score += _calculateLetterSensitivity(bookName, query) * 10.0;
    score += _calculateLetterSensitivity(authorName, query) * 8.0;

    // Fuzzy matching for typos and partial words
    score += _calculateFuzzyMatch(bookName, query) * 5.0;
    score += _calculateFuzzyMatch(authorName, query) * 4.0;

    return score;
  }

  double _calculateLetterSensitivity(String text, String query) {
    if (text.isEmpty || query.isEmpty) return 0.0;

    double sensitivity = 0.0;

    // Check for consecutive letter matches
    for (int i = 0; i <= text.length - query.length; i++) {
      int consecutiveMatches = 0;
      for (int j = 0; j < query.length && i + j < text.length; j++) {
        if (text[i + j] == query[j]) {
          consecutiveMatches++;
        } else {
          break;
        }
      }
      if (consecutiveMatches > 0) {
        sensitivity += consecutiveMatches / query.length;
      }
    }

    // Check for individual letter presence
    for (int i = 0; i < query.length; i++) {
      if (text.contains(query[i])) {
        sensitivity += 0.1;
      }
    }

    return sensitivity;
  }

  double _calculateFuzzyMatch(String text, String query) {
    if (text.isEmpty || query.isEmpty) return 0.0;

    // Simple fuzzy matching - count matching characters in order
    int matches = 0;
    int textIndex = 0;

    for (int queryIndex = 0; queryIndex < query.length; queryIndex++) {
      while (textIndex < text.length && text[textIndex] != query[queryIndex]) {
        textIndex++;
      }
      if (textIndex < text.length) {
        matches++;
        textIndex++;
      }
    }

    return matches / query.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: AnimatedBuilder(
          animation: _searchScaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _searchScaleAnimation.value,
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  gradient: _isSearchFocused
                      ? LinearGradient(
                          colors: [
                            Colors.white,
                            Tcolor.primary.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: _isSearchFocused ? null : Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: _isSearchFocused
                          ? Tcolor.primary.withOpacity(0.2)
                          : Colors.black.withOpacity(0.08),
                      blurRadius: _isSearchFocused ? 15 : 8,
                      offset: const Offset(0, 3),
                      spreadRadius: _isSearchFocused ? 1 : 0,
                    ),
                  ],
                  border: Border.all(
                    color: _isSearchFocused
                        ? Tcolor.primary
                        : Tcolor.subTitle.withOpacity(0.15),
                    width: _isSearchFocused ? 2.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.all(_isSearchFocused ? 4 : 2),
                        decoration: BoxDecoration(
                          color: _isSearchFocused
                              ? Tcolor.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: AnimatedRotation(
                          turns: _isSearchFocused ? 0.1 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            _isSearching
                                ? Icons.hourglass_empty
                                : _isSearchFocused
                                    ? Icons.search_rounded
                                    : Icons.search,
                            color: _isSearchFocused
                                ? Tcolor.primary
                                : Tcolor.subTitle.withOpacity(0.7),
                            size: _isSearchFocused ? 26 : 24,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: txtSearch,
                        style: TextStyle(
                          color: Tcolor.text,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                        decoration: InputDecoration(
                          hintText: _isSearchFocused
                              ? "Type to search instantly..."
                              : "Search books, authors, genres...",
                          hintStyle: TextStyle(
                            color: Tcolor.subTitle.withOpacity(0.6),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 17,
                            horizontal: 0,
                          ),
                        ),
                        cursorColor: Tcolor.primary,
                        cursorWidth: 2.5,
                        cursorHeight: 22,
                        onTap: () async {
                          _onSearchTap();
                          await Navigator.push(
                            context,
                            SlidePageRoute(
                              child: SearchForceView(
                                didSearch: (sText) {
                                  txtSearch.text = sText;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                              ),
                              direction: SlideDirection.rightToLeft,
                            ),
                          );
                          _onSearchComplete();
                          endEditing();
                        },
                        onChanged: (value) {
                          // Search is handled by the controller listener
                          // This ensures UI updates when text changes
                          if (mounted) {
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    if (txtSearch.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            txtSearch.clear();
                            setState(() {});
                          },
                          child: AnimatedScale(
                            scale: txtSearch.text.isNotEmpty ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.elasticOut,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.red.withOpacity(0.8),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 5),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: tagsArr.map((tagName) {
                  var index = tagsArr.indexOf(tagName);
                  return FadeInAnimation(
                    delay: Duration(milliseconds: 200 + (100 * index)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        gradient: selectTag == index
                            ? LinearGradient(
                                colors: [
                                  Tcolor.primary.withOpacity(0.15),
                                  Tcolor.primary.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: selectTag == index
                            ? null
                            : Tcolor.dColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: selectTag == index
                              ? Tcolor.primary
                              : Tcolor.subTitle.withOpacity(0.2),
                          width: selectTag == index ? 2 : 1,
                        ),
                        boxShadow: selectTag == index
                            ? [
                                BoxShadow(
                                  color: Tcolor.primary.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectTag = index;
                          });
                        },
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: selectTag == index
                                ? Tcolor.primary
                                : Tcolor.subTitle,
                            fontSize: selectTag == index ? 18 : 16,
                            fontWeight: selectTag == index
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                          child: Text(tagName),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (txtSearch.text.isEmpty)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Tcolor.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.explore_outlined,
                            color: Tcolor.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Explore Categories',
                              style: TextStyle(
                                color: Tcolor.text,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Discover books by genre',
                              style: TextStyle(
                                color: Tcolor.subTitle,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 15),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.75,
                                crossAxisCount: 2,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 15),
                        itemCount: searchArr.length,
                        itemBuilder: (context, index) {
                          var sObj = searchArr[index] as Map? ?? {};
                          return FadeInAnimation(
                            delay: Duration(milliseconds: 100 * index),
                            child: SlideInAnimation(
                              delay: Duration(milliseconds: 150 + (50 * index)),
                              begin: const Offset(0.0, 0.3),
                              child: SearchGridCell(
                                sObj: sObj,
                                index: index,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          if (txtSearch.text.isNotEmpty)
            Expanded(
              child: _isSearching
                  ? _buildSearchingWidget()
                  : _filteredResults.isEmpty
                      ? _buildNoResultsWidget()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Tcolor.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.search_rounded,
                                      color: Tcolor.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Search Results',
                                          style: TextStyle(
                                            color: Tcolor.text,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '${_filteredResults.length} book${_filteredResults.length == 1 ? '' : 's'} found for "${txtSearch.text}"',
                                          style: TextStyle(
                                            color: Tcolor.subTitle,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                itemCount: _filteredResults.length,
                                itemBuilder: (context, index) {
                                  var sObj = _filteredResults[index];
                                  return FadeInAnimation(
                                    delay: Duration(milliseconds: 50 * index),
                                    child: HistoryRow(
                                      sObj: sObj,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
            ),
        ],
      ),
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Tcolor.subTitle.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: Tcolor.subTitle.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInAnimation(
              delay: const Duration(milliseconds: 400),
              child: Text(
                'No books found',
                style: TextStyle(
                  color: Tcolor.text,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeInAnimation(
              delay: const Duration(milliseconds: 600),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Tcolor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Tcolor.primary.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  'No results for "${txtSearch.text}"',
                  style: TextStyle(
                    color: Tcolor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),
            FadeInAnimation(
              delay: const Duration(milliseconds: 800),
              child: Text(
                'Search suggestions:',
                style: TextStyle(
                  color: Tcolor.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            FadeInAnimation(
              delay: const Duration(milliseconds: 1000),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildSuggestionChip('History'),
                  _buildSuggestionChip('Fiction'),
                  _buildSuggestionChip('Business'),
                  _buildSuggestionChip('Romance'),
                  _buildSuggestionChip('Children'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String suggestion) {
    return GestureDetector(
      onTap: () {
        txtSearch.text = suggestion;
        _performSearch();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Tcolor.primary.withOpacity(0.15),
              Tcolor.primary.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Tcolor.primary.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Tcolor.primary.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_rounded,
              color: Tcolor.primary,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              suggestion,
              style: TextStyle(
                color: Tcolor.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Tcolor.primary),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Searching...',
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Finding books for "${txtSearch.text}"',
            style: TextStyle(
              color: Tcolor.subTitle,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
