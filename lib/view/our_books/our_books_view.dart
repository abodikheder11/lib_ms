import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';

class OurBooksView extends StatefulWidget {
  const OurBooksView({super.key});

  @override
  State<OurBooksView> createState() => _OurBooksViewState();
}

class _OurBooksViewState extends State<OurBooksView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _sortBy = 'Title';
  bool _isGridView = false;
  List<Map<String, dynamic>> _filteredBooks = [];

  final List<String> _categories = [
    'All',
    'Classic Literature',
    'Science Fiction',
    'Romance',
    'Coming of Age',
    'Fantasy',
  ];

  final List<String> _sortOptions = [
    'Title',
    'Author',
    'Rating',
    'Price',
    'Year',
  ];
  final List<Map<String, dynamic>> featuredBooks = [
    {
      "id": 1,
      "title": "The Heart Of Hell",
      "author": "Mitch Weiss",
      "image": "assets/images/s1.jpg",
      "description":
          "The untold story of courage and sacrifice in the shadow of Iwo Jima. A gripping tale of heroism during World War II.",
      "rating": 4.5,
      "price": 12.99,
      "category": "Classic Literature",
      "pages": 320,
      "publishYear": 2019,
    },
    {
      "id": 2,
      "title": "Ardennes 1944",
      "author": "Antony Beevor",
      "image": "assets/images/s2.jpg",
      "description":
          "International bestseller and award-winning history book about the Battle of the Bulge during World War II.",
      "rating": 4.8,
      "price": 14.99,
      "category": "Classic Literature",
      "pages": 456,
      "publishYear": 2015,
    },
    {
      "id": 3,
      "title": "War In The Gothic Line",
      "author": "Christian Jennings",
      "image": "assets/images/s3.jpg",
      "description":
          "Through the eyes of thirteen men & women from seven different nations during the Italian Campaign of WWII.",
      "rating": 4.7,
      "price": 13.99,
      "category": "Science Fiction",
      "pages": 384,
      "publishYear": 2017,
    },
    {
      "id": 4,
      "title": "Modern Romance",
      "author": "Aziz Ansari",
      "image": "assets/images/10.jpg",
      "description":
          "A hilarious and insightful look at modern dating culture, exploring how technology has changed the way we find love.",
      "rating": 4.6,
      "price": 11.99,
      "category": "Romance",
      "pages": 288,
      "publishYear": 2015,
    },
    {
      "id": 5,
      "title": "The Art of Living",
      "author": "Thich Nhat Hanh",
      "image": "assets/images/11.jpg",
      "description":
          "A guide to mindfulness and meditation, teaching readers how to live peacefully and mindfully in the present moment.",
      "rating": 4.3,
      "price": 13.49,
      "category": "Coming of Age",
      "pages": 224,
      "publishYear": 2017,
    },
    {
      "id": 6,
      "title": "Digital Minimalism",
      "author": "Cal Newport",
      "image": "assets/images/12.jpg",
      "description":
          "A philosophy for living better with less technology, helping readers reclaim their focus and well-being.",
      "rating": 4.9,
      "price": 15.99,
      "category": "Fantasy",
      "pages": 304,
      "publishYear": 2019,
    },
    {
      "id": 7,
      "title": "Biography Collection",
      "author": "Various Authors",
      "image": "assets/images/13.jpg",
      "description":
          "A comprehensive collection of inspiring biographies from influential figures throughout history.",
      "rating": 4.4,
      "price": 18.99,
      "category": "Classic Literature",
      "pages": 512,
      "publishYear": 2020,
    },
    {
      "id": 8,
      "title": "Culinary Adventures",
      "author": "Gordon Ramsay",
      "image": "assets/images/14.png",
      "description":
          "A cookbook filled with exciting recipes and culinary techniques from around the world.",
      "rating": 4.7,
      "price": 22.99,
      "category": "Romance",
      "pages": 368,
      "publishYear": 2021,
    },
    {
      "id": 9,
      "title": "Fiction Masterpiece",
      "author": "Margaret Atwood",
      "image": "assets/images/15.jpg",
      "description":
          "A thought-provoking work of fiction that explores themes of identity, society, and human nature.",
      "rating": 4.6,
      "price": 16.99,
      "category": "Science Fiction",
      "pages": 432,
      "publishYear": 2018,
    },
    {
      "id": 10,
      "title": "Children's Wonder",
      "author": "Roald Dahl",
      "image": "assets/images/16.jpg",
      "description":
          "A delightful children's book filled with imagination, adventure, and valuable life lessons.",
      "rating": 4.8,
      "price": 9.99,
      "category": "Coming of Age",
      "pages": 192,
      "publishYear": 2016,
    },
    {
      "id": 11,
      "title": "Business Strategy",
      "author": "Michael Porter",
      "image": "assets/images/17.jpg",
      "description":
          "Essential business strategies and insights for entrepreneurs and business leaders in the modern economy.",
      "rating": 4.5,
      "price": 24.99,
      "category": "Fantasy",
      "pages": 448,
      "publishYear": 2019,
    },
    {
      "id": 12,
      "title": "Graphic Novel Epic",
      "author": "Neil Gaiman",
      "image": "assets/images/18.jpg",
      "description":
          "A stunning graphic novel that combines beautiful artwork with compelling storytelling.",
      "rating": 4.9,
      "price": 19.99,
      "category": "Fantasy",
      "pages": 256,
      "publishYear": 2020,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _filteredBooks = List.from(featuredBooks);
    _animationController.forward();

    _searchController.addListener(_filterBooks);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterBooks() {
    setState(() {
      _filteredBooks = featuredBooks.where((book) {
        final matchesSearch = book['title']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()) ||
            book['author']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

        final matchesCategory =
            _selectedCategory == 'All' || book['category'] == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();

      _sortBooks();
    });
  }

  void _sortBooks() {
    _filteredBooks.sort((a, b) {
      switch (_sortBy) {
        case 'Title':
          return a['title'].toString().compareTo(b['title'].toString());
        case 'Author':
          return a['author'].toString().compareTo(b['author'].toString());
        case 'Rating':
          return b['rating'].compareTo(a['rating']);
        case 'Price':
          return a['price'].compareTo(b['price']);
        case 'Year':
          return b['publishYear'].compareTo(a['publishYear']);
        default:
          return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(
            children: [
              _buildHeaderSection(),
              _buildSearchAndFilters(),
              Expanded(
                child: _buildBooksContent(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isGridView = !_isGridView;
          });
        },
        backgroundColor: Tcolor.primary,
        child: Icon(
          _isGridView ? Icons.list : Icons.grid_view,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Tcolor.text),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Our Books',
        style: TextStyle(
          color: Tcolor.text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _isGridView ? Icons.list : Icons.grid_view,
            color: Tcolor.text,
          ),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
        PopupMenuButton<String>(
          icon: Icon(Icons.sort, color: Tcolor.text),
          onSelected: (value) {
            setState(() {
              _sortBy = value;
              _filterBooks();
            });
          },
          itemBuilder: (context) => _sortOptions
              .map((option) => PopupMenuItem(
                    value: option,
                    child: Row(
                      children: [
                        Icon(
                          _getSortIcon(option),
                          color: _sortBy == option
                              ? Tcolor.primary
                              : Tcolor.subTitle,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sort by $option',
                          style: TextStyle(
                            color: _sortBy == option
                                ? Tcolor.primary
                                : Tcolor.text,
                            fontWeight: _sortBy == option
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  IconData _getSortIcon(String sortOption) {
    switch (sortOption) {
      case 'Title':
        return Icons.title;
      case 'Author':
        return Icons.person;
      case 'Rating':
        return Icons.star;
      case 'Price':
        return Icons.attach_money;
      case 'Year':
        return Icons.calendar_today;
      default:
        return Icons.sort;
    }
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Tcolor.dColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Tcolor.primaryLight.withOpacity(0.3)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search books or authors...',
                hintStyle: TextStyle(color: Tcolor.subTitle),
                prefixIcon: Icon(Icons.search, color: Tcolor.primary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Tcolor.subTitle),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Category Filter
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                      _filterBooks();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Tcolor.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Tcolor.primary : Tcolor.subTitle,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Tcolor.text,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksContent() {
    if (_filteredBooks.isEmpty) {
      return _buildEmptyState();
    }

    return _isGridView ? _buildGridView() : _buildListView();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Tcolor.subTitle,
          ),
          const SizedBox(height: 16),
          Text(
            'No books found',
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Tcolor.subTitle,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 12,
          mainAxisSpacing: 16,
        ),
        itemCount: _filteredBooks.length,
        itemBuilder: (context, index) {
          final book = _filteredBooks[index];
          return _buildGridBookCard(book, index);
        },
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _filteredBooks.length,
      itemBuilder: (context, index) {
        final book = _filteredBooks[index];
        return _buildBookCard(book);
      },
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Tcolor.primary, Tcolor.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Discover Amazing Books',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Explore our curated collection of timeless classics and modern masterpieces',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard('${featuredBooks.length}', 'Books'),
              const SizedBox(width: 12),
              _buildStatCard('6', 'Categories'),
              const SizedBox(width: 12),
              _buildStatCard('4.7', 'Avg Rating'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridBookCard(Map<String, dynamic> book, int index) {
    return Hero(
      tag: 'grid_book_${book["id"]}',
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: Image.asset(
                    book["image"],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Tcolor.dColor,
                      child: Icon(
                        Icons.book,
                        color: Tcolor.subTitle,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book["title"],
                      style: TextStyle(
                        color: Tcolor.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book["author"],
                      style: TextStyle(
                        color: Tcolor.subTitle,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              book["rating"].toString(),
                              style: TextStyle(
                                color: Tcolor.text,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '\$${book["price"]}',
                          style: TextStyle(
                            color: Tcolor.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBookImage(book),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBookInfo(book),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookImage(Map<String, dynamic> book) {
    return Hero(
      tag: 'book_${book["id"]}',
      child: Container(
        width: 80,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            book["image"],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Tcolor.dColor,
              child: Icon(
                Icons.book,
                color: Tcolor.subTitle,
                size: 40,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookInfo(Map<String, dynamic> book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          book["title"],
          style: TextStyle(
            color: Tcolor.text,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'by ${book["author"]}',
          style: TextStyle(
            color: Tcolor.primary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          book["description"],
          style: TextStyle(
            color: Tcolor.subTitle,
            fontSize: 12,
            height: 1.4,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
        _buildBookDetails(book),
        const SizedBox(height: 12),
        _buildActionButtons(book),
      ],
    );
  }

  Widget _buildBookDetails(Map<String, dynamic> book) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        _buildDetailChip(
          icon: Icons.star,
          text: book["rating"].toString(),
          color: Colors.amber,
        ),
        _buildDetailChip(
          icon: Icons.category,
          text: book["category"],
          color: Tcolor.primary,
        ),
        _buildDetailChip(
          icon: Icons.pages,
          text: '${book["pages"]} pages',
          color: Tcolor.color2,
        ),
      ],
    );
  }

  Widget _buildDetailChip({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> book) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 32,
            child: ElevatedButton.icon(
              onPressed: () => _onAddToCart(book),
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 14,
                color: Colors.white,
              ),
              label: Text(
                '\$${book["price"]}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Tcolor.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 32,
          child: IconButton(
            onPressed: () => _onAddToWishlist(book),
            icon: Icon(
              Icons.favorite_outline,
              color: Tcolor.color2,
              size: 18,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Tcolor.color2.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onAddToCart(Map<String, dynamic> book) {
    debugPrint('Added to cart: ${book["title"]}');
    // Implement cart functionality
  }

  void _onAddToWishlist(Map<String, dynamic> book) {
    debugPrint('Added to wishlist: ${book["title"]}');
    // Implement wishlist functionality
  }
}
