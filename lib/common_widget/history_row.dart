import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lib_ms/common/color__extention.dart';

class HistoryRow extends StatelessWidget {
  final Map<dynamic, dynamic> sObj;

  const HistoryRow({super.key, required this.sObj});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _onItemTap(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookCover(context),
              const SizedBox(width: 12),
              Expanded(
                child: _buildBookDetails(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookCover(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final imageUrl = sObj["img"]?.toString() ?? '';

    return Hero(
      tag: 'book_${sObj["id"] ?? sObj["name"]}',
      child: Container(
        width: media.width * 0.22,
        height: media.width * 0.22 * 1.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: imageUrl.isNotEmpty
              ? Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Tcolor.dColor,
      child: Icon(
        Icons.book,
        color: Tcolor.subTitle,
        size: 32,
      ),
    );
  }

  Widget _buildBookDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        const SizedBox(height: 6),
        _buildAuthor(),
        const SizedBox(height: 8),
        _buildDescription(),
        const SizedBox(height: 8),
        _buildRating(),
        const SizedBox(height: 4),
        _buildAdditionalInfo(),
        const SizedBox(height: 8),
        _buildAddToCartButton(),
      ],
    );
  }

  Widget _buildTitle() {
    final title = sObj["name"]?.toString() ?? 'Unknown Title';

    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: Tcolor.text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
    );
  }

  Widget _buildAuthor() {
    final author = sObj["auther"]?.toString() ??
        sObj["authar"]?.toString() ??
        sObj["author"]?.toString() ??
        'Unknown Author';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Tcolor.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Tcolor.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.person,
            size: 14,
            color: Tcolor.primary,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              'by $author',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Tcolor.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    final description =
        sObj["description"]?.toString() ?? sObj["desc"]?.toString() ?? '';

    if (description.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Tcolor.dColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Tcolor.primaryLight.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.description_outlined,
            size: 14,
            color: Tcolor.primary,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Tcolor.text.withOpacity(0.8),
                fontSize: 11,
                fontWeight: FontWeight.w400,
                height: 1.4,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRating() {
    final rating = double.tryParse(
            sObj["rate"]?.toString() ?? sObj["rating"]?.toString() ?? '0') ??
        0.0;

    return Row(
      children: [
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: Tcolor.primary,
          ),
          itemCount: 5,
          itemSize: 14,
          unratedColor: Tcolor.subTitle.withOpacity(0.3),
        ),
        const SizedBox(width: 6),
        Text(
          rating > 0 ? rating.toStringAsFixed(1) : 'No rating',
          style: TextStyle(
            color: Tcolor.subTitle,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    final readDate = sObj["readDate"]?.toString();
    final category = sObj["category"]?.toString();

    if (readDate == null && category == null) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (readDate != null)
          _buildInfoChip(
            icon: Icons.access_time,
            label: readDate,
          ),
        if (category != null)
          _buildInfoChip(
            icon: Icons.category_outlined,
            label: category,
          ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Tcolor.primaryLight.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: Tcolor.primary,
          ),
          const SizedBox(width: 2),
          Text(
            label,
            style: TextStyle(
              color: Tcolor.primary,
              fontSize: 9,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddToCartButton() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 32,
            child: ElevatedButton.icon(
              onPressed: () => _onAddToCart(),
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 14,
                color: Colors.white,
              ),
              label: const Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Tcolor.primary,
                foregroundColor: Colors.white,
                elevation: 1,
                shadowColor: Tcolor.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SizedBox(
            height: 32,
            child: ElevatedButton.icon(
              onPressed: () => _onAddToWishlist(),
              icon: const Icon(
                Icons.favorite_outline,
                size: 14,
                color: Colors.white,
              ),
              label: const Text(
                'Wishlist',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Tcolor.color2,
                foregroundColor: Colors.white,
                elevation: 1,
                shadowColor: Tcolor.color2.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onAddToCart() {
    // Handle add to cart functionality
    final bookName = sObj["name"]?.toString() ?? 'Unknown Book';
    debugPrint('Added to cart: $bookName');

    // You can implement cart functionality here:
    // - Add to cart state management
    // - Show snackbar confirmation
    // - Update cart count
    // - Navigate to cart page
  }

  void _onAddToWishlist() {
    // Handle add to wishlist functionality
    final bookName = sObj["name"]?.toString() ?? 'Unknown Book';
    debugPrint('Added to wishlist: $bookName');

    // You can implement wishlist functionality here:
    // - Add to wishlist state management
    // - Show snackbar confirmation
    // - Update wishlist count
    // - Toggle wishlist status
    // - Navigate to wishlist page
  }

  void _onItemTap(BuildContext context) {
    // Handle item tap - navigate to book details or perform action
    // You can implement navigation logic here
    debugPrint('Tapped on book: ${sObj["name"]}');
  }
}
