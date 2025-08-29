import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/view/onbording/welcome_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';


class UserDataStorage {
  static Map<String, dynamic> _userData = {
    'firstName': 'Sarah',
    'lastName': 'Johnson',
    'email': 'sarah.johnson@gmail.com',
    'phone': '+1 (555) 987-6543',
    'joinDate': '2023-08-15',
    'membershipType': 'Premium',
    'profileImage': null,
  };

  static Map<String, dynamic> getUserData() => Map.from(_userData);

  static void saveUserData(Map<String, dynamic> data) {
    _userData.addAll(data);
  }

  static void updateField(String key, dynamic value) {
    _userData[key] = value;
  }
}

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  Map<String, dynamic> userInfo = {};

  final Map<String, int> userStats = {
    'booksRead': 47,
    'favoriteBooks': 18,
    'cartItems': 5,
    'reviewsWritten': 23,
    'booksOwned': 156,
  };

  String get fullName => '${userInfo['firstName']} ${userInfo['lastName']}';
  String get userEmail => userInfo['email'] ?? 'No email provided';
  String get userPhone => userInfo['phone'] ?? 'No phone provided';
  String get membershipType => userInfo['membershipType'] ?? 'Basic';
  String get joinDate => userInfo['joinDate'] ?? 'Unknown';

  int get booksRead => userStats['booksRead'] ?? 0;
  int get favoriteBooks => userStats['favoriteBooks'] ?? 0;
  int get cartItems => userStats['cartItems'] ?? 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final savedData = UserDataStorage.getUserData();

      setState(() {
        userInfo = savedData;
      });

      debugPrint('User data loaded successfully');
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> _saveUserData() async {
    try {
      UserDataStorage.saveUserData(userInfo);

      debugPrint('User data saved successfully');
    } catch (e) {
      debugPrint('Error saving user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final profile = state.profile;

            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(profile),
                  const SizedBox(height: 20),
                  _buildStatsSection(),
                  const SizedBox(height: 30),
                  _buildMenuSection(),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),

      floatingActionButton: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoaded) {
            final profile = state.profile;

            return FutureBuilder<bool>(
              future: _getIsAuthor(profile['email']),
              builder: (context, snapshot) {
                final isAuthor = snapshot.data ?? false;
                if (!isAuthor) return const SizedBox.shrink();

                return FloatingActionButton(
                  onPressed: () => _openAddBookModal(context),
                  child: const Icon(Icons.add),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
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
        'My Account',
        style: TextStyle(
          color: Tcolor.text,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.edit, color: Tcolor.primary),
          onPressed: () {
            _showEditProfileDialog();
          },
        ),
      ],
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> profile) {
    return FutureBuilder<bool>(
      future: _getIsAuthor(profile['email']),
      builder: (context, snapshot) {
        final isAuthor = snapshot.data ?? false;
        print(isAuthor);

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
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: Tcolor.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${profile['firstname'] ?? 'User'} ${profile['lastname'] ?? ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isAuthor ? "Author" : "Member",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email_outlined,
                      color: Colors.white.withOpacity(0.8), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    profile['email'] ?? '',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined,
                      color: Colors.white.withOpacity(0.8), size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'Member since ${_formatDate(profile['created_at'] ?? '')}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatCard(
                icon: Icons.book_outlined,
                title: 'Books Read',
                value: booksRead.toString(),
                color: Tcolor.primary,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                icon: Icons.favorite_outline,
                title: 'Favorites',
                value: favoriteBooks.toString(),
                color: Tcolor.color2,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                icon: Icons.shopping_cart_outlined,
                title: 'In Cart',
                value: cartItems.toString(),
                color: Tcolor.color3,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                icon: Icons.rate_review_outlined,
                title: 'Reviews',
                value: userStats['reviewsWritten'].toString(),
                color: Tcolor.color1,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                icon: Icons.library_books_outlined,
                title: 'Owned',
                value: userStats['booksOwned'].toString(),
                color: Colors.purple,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                icon: Icons.trending_up,
                title: 'Reading Goal',
                value: '${(booksRead * 100 / 50).round()}%',
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Tcolor.text,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: TextStyle(
              color: Tcolor.text,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Update your personal information',
            onTap: () => _showEditProfileDialog(),
          ),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage your notification preferences',
            onTap: () => _showNotificationSettings(),
          ),
          _buildMenuItem(
            icon: Icons.security_outlined,
            title: 'Privacy & Security',
            subtitle: 'Password and security settings',
            onTap: () => _showSecuritySettings(),
          ),
          _buildMenuItem(
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            subtitle: 'Manage your payment options',
            onTap: () => _showPaymentMethods(),
          ),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            subtitle: 'Get help and contact support',
            onTap: () => _showHelpSupport(),
          ),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'About',
            subtitle: 'App version and information',
            onTap: () => _showAbout(),
          ),
          const SizedBox(height: 20),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Sign Out',
            subtitle: 'Sign out of your account',
            onTap: () => _showSignOutDialog(),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.withOpacity(0.05)
                : Tcolor.dColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDestructive
                  ? Colors.red.withOpacity(0.2)
                  : Tcolor.primaryLight.withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withOpacity(0.1)
                      : Tcolor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? Colors.red : Tcolor.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isDestructive ? Colors.red : Tcolor.text,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: isDestructive
                            ? Colors.red.withOpacity(0.7)
                            : Tcolor.subTitle,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isDestructive
                    ? Colors.red.withOpacity(0.7)
                    : Tcolor.subTitle,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog() {
    final TextEditingController firstNameController =
        TextEditingController(text: userInfo['firstName']);
    final TextEditingController lastNameController =
        TextEditingController(text: userInfo['lastName']);
    final TextEditingController emailController =
        TextEditingController(text: userInfo['email']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.edit,
              color: Tcolor.primary,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Edit Profile',
              style: TextStyle(
                color: Tcolor.text,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildEditField(
                controller: firstNameController,
                label: 'First Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildEditField(
                controller: lastNameController,
                label: 'Last Name',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildEditField(
                controller: emailController,
                label: 'Email Address',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Tcolor.subTitle,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _updateProfile(
                firstNameController.text,
                lastNameController.text,
                emailController.text,
              );
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Tcolor.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings() {
    debugPrint('Navigate to Notification Settings');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification settings coming soon!'),
        backgroundColor: Tcolor.primary,
      ),
    );
  }

  void _showSecuritySettings() {
    debugPrint('Navigate to Security Settings');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Security settings coming soon!'),
        backgroundColor: Tcolor.primary,
      ),
    );
  }

  void _showPaymentMethods() {
    debugPrint('Navigate to Payment Methods');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Payment methods coming soon!'),
        backgroundColor: Tcolor.primary,
      ),
    );
  }

  void _showHelpSupport() {
    debugPrint('Navigate to Help & Support');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Help & support coming soon!'),
        backgroundColor: Tcolor.primary,
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'About Library MS',
          style: TextStyle(
            color: Tcolor.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Library Management System'),
            const SizedBox(height: 8),
            const Text('Version: 1.0.0'),
            const SizedBox(height: 8),
            Text(
              'A modern library management app for book lovers.',
              style: TextStyle(color: Tcolor.subTitle),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: Tcolor.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Out',
          style: TextStyle(
            color: Tcolor.text,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Tcolor.subTitle),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('auth_token');

              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const WelcomeView()),
                      (route) => false,
                );
              }

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Signed out successfully!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildEditField({
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

  Future<void> _updateProfile(
      String firstName, String lastName, String email) async {

    if (firstName.trim().isEmpty ||
        lastName.trim().isEmpty ||
        email.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }


    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      userInfo['firstName'] = firstName.trim();
      userInfo['lastName'] = lastName.trim();
      userInfo['email'] = email.trim();
    });

    await _saveUserData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile updated and saved successfully!'),
          backgroundColor: Tcolor.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }

    debugPrint('Profile updated and saved: $firstName $lastName - $email');
  }
}
Future<bool> _getIsAuthor(String? email) async {
  if (email == null) return false;
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_author') ?? false;
}
void _openAddBookModal(BuildContext context) {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Add New Book",
                style: Theme.of(ctx)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Book Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                final title = titleController.text.trim();
                final desc = descController.text.trim();

                if (title.isEmpty) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text("Please enter a title")),
                  );
                  return;
                }

                print("Book added: $title - $desc");

                Navigator.pop(ctx);
              },
              icon: const Icon(Icons.save , color: Colors.green,),
              label: const Text("Save", style: TextStyle(color: Colors.green,),),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}
