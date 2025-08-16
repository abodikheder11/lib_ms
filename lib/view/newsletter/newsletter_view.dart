import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';

class NewsletterView extends StatefulWidget {
  const NewsletterView({super.key});

  @override
  State<NewsletterView> createState() => _NewsletterViewState();
}

class _NewsletterViewState extends State<NewsletterView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isSubscribed = false;
  
  final List<String> selectedCategories = [];
  final List<Map<String, dynamic>> categories = [
    {'name': 'New Releases', 'icon': Icons.new_releases, 'color': Colors.blue},
    {'name': 'Best Sellers', 'icon': Icons.star, 'color': Colors.amber},
    {'name': 'Academic Books', 'icon': Icons.school, 'color': Colors.green},
    {'name': 'Fiction', 'icon': Icons.auto_stories, 'color': Colors.purple},
    {'name': 'Non-Fiction', 'icon': Icons.fact_check, 'color': Colors.orange},
    {'name': 'Children\'s Books', 'icon': Icons.child_care, 'color': Colors.pink},
    {'name': 'Special Offers', 'icon': Icons.local_offer, 'color': Colors.red},
    {'name': 'Author Interviews', 'icon': Icons.mic, 'color': Colors.teal},
  ];

  final List<Map<String, dynamic>> benefits = [
    {
      'icon': Icons.notifications_active,
      'title': 'Early Access',
      'description': 'Be the first to know about new book releases',
    },
    {
      'icon': Icons.discount,
      'title': 'Exclusive Discounts',
      'description': 'Get special offers and discount codes',
    },
    {
      'icon': Icons.book_online,
      'title': 'Reading Recommendations',
      'description': 'Personalized book suggestions based on your interests',
    },
    {
      'icon': Icons.event,
      'title': 'Event Invitations',
      'description': 'Invites to book launches and author events',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Tcolor.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Newsletter',
          style: TextStyle(
            color: Tcolor.text,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeroSection(),
                const SizedBox(height: 30),
                _buildBenefitsSection(),
                const SizedBox(height: 30),
                _buildSubscriptionForm(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Tcolor.primary, Tcolor.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Tcolor.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.email_outlined,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          const Text(
            'Stay Updated with Our Newsletter!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Get the latest book recommendations, exclusive offers, and literary news delivered to your inbox.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What You\'ll Get',
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ...benefits.map((benefit) => _buildBenefitItem(benefit)).toList(),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(Map<String, dynamic> benefit) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Tcolor.dColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Tcolor.primaryLight.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Tcolor.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              benefit['icon'],
              color: Tcolor.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit['title'],
                  style: TextStyle(
                    color: Tcolor.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  benefit['description'],
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
    );
  }

  Widget _buildSubscriptionForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subscribe Now',
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          _buildInputField(
            controller: _nameController,
            label: 'Your Name',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 15),
          _buildInputField(
            controller: _emailController,
            label: 'Email Address',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 20),
          Text(
            'Choose Your Interests',
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          _buildCategorySelection(),
          const SizedBox(height: 30),
          _buildSubscribeButton(),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Tcolor.dColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Tcolor.primaryLight.withOpacity(0.3),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: Tcolor.text,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Tcolor.subTitle,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            icon,
            color: Tcolor.primary,
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {
        final isSelected = selectedCategories.contains(category['name']);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedCategories.remove(category['name']);
              } else {
                selectedCategories.add(category['name']);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? category['color'].withOpacity(0.2)
                  : Tcolor.dColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? category['color']
                    : Tcolor.subTitle.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category['icon'],
                  size: 16,
                  color: isSelected
                      ? category['color']
                      : Tcolor.subTitle,
                ),
                const SizedBox(width: 6),
                Text(
                  category['name'],
                  style: TextStyle(
                    color: isSelected
                        ? category['color']
                        : Tcolor.subTitle,
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubscribeButton() {
    return Container(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isSubscribed ? null : _handleSubscribe,
        style: ElevatedButton.styleFrom(
          backgroundColor: _isSubscribed ? Colors.green : Tcolor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        child: _isSubscribed
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text(
                    'Subscribed!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : const Text(
                'Subscribe to Newsletter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _handleSubscribe() {
    if (_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubscribed = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Welcome ${_nameController.text}! You\'ve successfully subscribed to our newsletter.',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );

    // Here you would typically send the data to your backend
    debugPrint('Newsletter subscription: ${_nameController.text}, ${_emailController.text}');
    debugPrint('Selected categories: $selectedCategories');
  }
}
