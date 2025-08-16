import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';

class SellWithUsView extends StatefulWidget {
  const SellWithUsView({super.key});

  @override
  State<SellWithUsView> createState() => _SellWithUsViewState();
}

class _SellWithUsViewState extends State<SellWithUsView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> benefits = [
    {
      'icon': Icons.monetization_on,
      'title': 'Earn Money',
      'description': 'Get up to 70% of your book\'s selling price',
      'color': Colors.green,
    },
    {
      'icon': Icons.eco,
      'title': 'Go Green',
      'description': 'Help reduce waste by giving books a second life',
      'color': Colors.teal,
    },
    {
      'icon': Icons.people,
      'title': 'Help Students',
      'description': 'Make education more affordable for others',
      'color': Colors.blue,
    },
    {
      'icon': Icons.flash_on,
      'title': 'Quick Process',
      'description': 'Sell your books in just 3 simple steps',
      'color': Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> steps = [
    {
      'step': '1',
      'title': 'List Your Books',
      'description': 'Take photos and add details about your books',
      'icon': Icons.camera_alt,
    },
    {
      'step': '2',
      'title': 'Set Your Price',
      'description': 'We suggest optimal pricing based on market data',
      'icon': Icons.price_change,
    },
    {
      'step': '3',
      'title': 'Get Paid',
      'description': 'Receive payment instantly when your book sells',
      'icon': Icons.payment,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      curve: Curves.easeOutBack,
    ));
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
          'Sell With Us',
          style: TextStyle(
            color: Tcolor.text,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
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
                    _buildHowItWorksSection(),
                    const SizedBox(height: 30),
                    _buildStatsSection(),
                    const SizedBox(height: 30),
                    _buildActionSection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeroSection() {
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
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.sell_outlined,
            size: 80,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          const Text(
            'Turn Your Books Into Cash',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'Join thousands of sellers who have earned money by selling their unused books',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
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
            'Why Sell With Us?',
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
            ),
            itemCount: benefits.length,
            itemBuilder: (context, index) {
              final benefit = benefits[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: benefit['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: benefit['color'].withOpacity(0.3),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      benefit['icon'],
                      size: 40,
                      color: benefit['color'],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      benefit['title'],
                      style: TextStyle(
                        color: benefit['color'],
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      benefit['description'],
                      style: TextStyle(
                        color: Tcolor.text,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHowItWorksSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How It Works',
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ...steps.map((step) => _buildStepCard(step)).toList(),
        ],
      ),
    );
  }

  Widget _buildStepCard(Map<String, dynamic> step) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Tcolor.dColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Tcolor.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Tcolor.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                step['step'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step['title'],
                  style: TextStyle(
                    color: Tcolor.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  step['description'],
                  style: TextStyle(
                    color: Tcolor.subTitle,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            step['icon'],
            color: Tcolor.primary,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Tcolor.primary.withOpacity(0.1),
            Tcolor.primaryLight.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('15K+', 'Books Sold'),
          _buildStatItem('98%', 'Satisfaction'),
          _buildStatItem('24h', 'Avg. Sell Time'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            color: Tcolor.primary,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Tcolor.text,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _showSellBookDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Tcolor.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'Start Selling Now',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              _showContactDialog();
            },
            child: Text(
              'Have questions? Contact us',
              style: TextStyle(
                color: Tcolor.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSellBookDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.sell, color: Tcolor.primary),
            const SizedBox(width: 8),
            const Text('Sell Your Books'),
          ],
        ),
        content: const Text(
          'Ready to start selling? We\'ll guide you through the process step by step.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later', style: TextStyle(color: Tcolor.subTitle)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Sell feature coming soon!'),
                  backgroundColor: Tcolor.primary,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Tcolor.primary,
            ),
            child: const Text('Get Started',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.support_agent, color: Tcolor.primary),
            const SizedBox(width: 8),
            const Text('Contact Support'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Get in touch with our support team:'),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.email, color: Tcolor.primary),
                const SizedBox(width: 8),
                const Text('support@libms.com'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, color: Tcolor.primary),
                const SizedBox(width: 8),
                const Text('+1 (555) 123-4567'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Tcolor.primary)),
          ),
        ],
      ),
    );
  }
}
