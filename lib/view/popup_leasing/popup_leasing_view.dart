import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';

class PopupLeasingView extends StatefulWidget {
  const PopupLeasingView({super.key});

  @override
  State<PopupLeasingView> createState() => _PopupLeasingViewState();
}

class _PopupLeasingViewState extends State<PopupLeasingView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int selectedPackage = -1;
  
  final List<Map<String, dynamic>> packages = [
    {
      'name': 'Starter Pop-up',
      'duration': '1 Week',
      'price': '\$299',
      'features': [
        'Prime location setup',
        'Basic book display',
        'Payment processing',
        'Daily sales reports',
      ],
      'color': Colors.blue,
      'popular': false,
    },
    {
      'name': 'Business Pop-up',
      'duration': '1 Month',
      'price': '\$899',
      'features': [
        'Premium location',
        'Professional display setup',
        'Marketing support',
        'Customer analytics',
        'Staff training included',
      ],
      'color': Colors.green,
      'popular': true,
    },
    {
      'name': 'Enterprise Pop-up',
      'duration': '3 Months',
      'price': '\$2,499',
      'features': [
        'Multiple locations',
        'Custom branding',
        'Dedicated support',
        'Advanced analytics',
        'Marketing campaigns',
        'Event organization',
      ],
      'color': Colors.purple,
      'popular': false,
    },
  ];

  final List<Map<String, dynamic>> benefits = [
    {
      'icon': Icons.location_on,
      'title': 'Prime Locations',
      'description': 'Access to high-traffic areas in malls, universities, and business districts',
    },
    {
      'icon': Icons.trending_up,
      'title': 'Boost Sales',
      'description': 'Increase your book sales with temporary retail presence',
    },
    {
      'icon': Icons.people,
      'title': 'Reach New Customers',
      'description': 'Connect with readers who prefer physical book browsing',
    },
    {
      'icon': Icons.support_agent,
      'title': 'Full Support',
      'description': 'Complete setup, management, and teardown services',
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
          'Pop-up Leasing',
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
                _buildPackagesSection(),
                const SizedBox(height: 30),
                _buildActionSection(),
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
            Icons.store_outlined,
            size: 60,
            color: Colors.white,
          ),
          const SizedBox(height: 15),
          const Text(
            'Pop-up Book Stores',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            'Create temporary retail presence in high-traffic locations. Perfect for book launches, seasonal sales, or testing new markets.',
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
            'Why Choose Pop-up Leasing?',
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

  Widget _buildPackagesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Package',
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ...packages.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> package = entry.value;
            return _buildPackageCard(package, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> package, int index) {
    final isSelected = selectedPackage == index;
    final isPopular = package['popular'] ?? false;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPackage = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: isSelected
              ? package['color'].withOpacity(0.1)
              : Tcolor.dColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? package['color']
                : Tcolor.primaryLight.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: package['color'].withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package['name'],
                            style: TextStyle(
                              color: Tcolor.text,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            package['duration'],
                            style: TextStyle(
                              color: Tcolor.subTitle,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        package['price'],
                        style: TextStyle(
                          color: package['color'],
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ...package['features'].map<Widget>((feature) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: package['color'],
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              feature,
                              style: TextStyle(
                                color: Tcolor.text,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            if (isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: selectedPackage >= 0 ? _handleBooking : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedPackage >= 0 ? Tcolor.primary : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
              ),
              child: Text(
                selectedPackage >= 0
                    ? 'Book ${packages[selectedPackage]['name']}'
                    : 'Select a Package',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          TextButton(
            onPressed: _showContactDialog,
            child: Text(
              'Need Custom Solution? Contact Us',
              style: TextStyle(
                color: Tcolor.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBooking() {
    if (selectedPackage >= 0) {
      final package = packages[selectedPackage];
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Book ${package['name']}',
            style: TextStyle(
              color: Tcolor.text,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Package: ${package['name']}'),
              Text('Duration: ${package['duration']}'),
              Text('Price: ${package['price']}'),
              const SizedBox(height: 10),
              const Text('Our team will contact you within 24 hours to discuss location options and setup details.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Tcolor.subTitle),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Booking request submitted for ${package['name']}!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Tcolor.primary,
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Text(
          'Custom Solutions',
          style: TextStyle(
            color: Tcolor.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Need a custom pop-up solution? Our team can help with:'),
            const SizedBox(height: 10),
            const Text('• Extended duration leases'),
            const Text('• Multiple location packages'),
            const Text('• Special event setups'),
            const Text('• Custom branding solutions'),
            const SizedBox(height: 15),
            const Text('Contact our business team:'),
            const Text('📧 business@libraryms.com'),
            const Text('📞 +1 (555) 123-4567'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: TextStyle(color: Tcolor.primary),
            ),
          ),
        ],
      ),
    );
  }
}
