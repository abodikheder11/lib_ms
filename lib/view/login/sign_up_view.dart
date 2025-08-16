import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/common_widget/round_button.dart';
import 'package:lib_ms/common_widget/round_textfield.dart';
import 'package:lib_ms/view/main_tab/main_tab_view.dart';
import 'package:lib_ms/common/page_transitions.dart';
import 'package:lib_ms/common/animated_widgets.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtFirstName = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtMobile = TextEditingController();
  TextEditingController txtCode = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  TextEditingController txtConfirmPassword = TextEditingController();
  bool isStay = false;
  bool _isFormValid = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _nameError;
  String? _emailError;
  String? _mobileError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers for required fields
    txtFirstName.addListener(_validateForm);
    txtEmail.addListener(_validateForm);
    txtMobile.addListener(_validateForm);
    txtPassword.addListener(_validateForm);
    txtConfirmPassword.addListener(_validateForm);
  }

  @override
  void dispose() {
    txtFirstName.dispose();
    txtEmail.dispose();
    txtMobile.dispose();
    txtCode.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidMobile(String mobile) {
    return RegExp(r'^[+]?[0-9]{10,15}$').hasMatch(mobile.replaceAll(' ', ''));
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  bool _isValidName(String name) {
    return name.trim().length >= 2 && RegExp(r'^[a-zA-Z\s]+$').hasMatch(name);
  }

  void _validateForm() {
    setState(() {
      final name = txtFirstName.text.trim();
      final email = txtEmail.text.trim();
      final mobile = txtMobile.text.trim();
      final password = txtPassword.text.trim();
      final confirmPassword = txtConfirmPassword.text.trim();

      // Name validation
      if (name.isEmpty) {
        _nameError = null;
      } else if (!_isValidName(name)) {
        _nameError = "Please enter a valid name (letters only, min 2 chars)";
      } else {
        _nameError = null;
      }

      // Email validation
      if (email.isEmpty) {
        _emailError = null;
      } else if (!_isValidEmail(email)) {
        _emailError = "Please enter a valid email address";
      } else {
        _emailError = null;
      }

      // Mobile validation
      if (mobile.isEmpty) {
        _mobileError = null;
      } else if (!_isValidMobile(mobile)) {
        _mobileError = "Please enter a valid mobile number";
      } else {
        _mobileError = null;
      }

      // Password validation
      if (password.isEmpty) {
        _passwordError = null;
      } else if (!_isValidPassword(password)) {
        _passwordError = "Password must be at least 6 characters";
      } else {
        _passwordError = null;
      }

      // Confirm password validation
      if (confirmPassword.isEmpty) {
        _confirmPasswordError = null;
      } else if (password != confirmPassword) {
        _confirmPasswordError = "Passwords do not match";
      } else {
        _confirmPasswordError = null;
      }

      _isFormValid = name.isNotEmpty &&
          email.isNotEmpty &&
          mobile.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          _nameError == null &&
          _emailError == null &&
          _mobileError == null &&
          _passwordError == null &&
          _confirmPasswordError == null;
    });
  }

  Future<void> _signUp() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        Navigator.of(context).pushReplacement(
          FadePageRoute(
            child: const MainTabView(),
            duration: const Duration(milliseconds: 500),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign up failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Tcolor.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                    color: Tcolor.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              ////////////////////////////
              RoundTextField(
                controller: txtFirstName,
                hintText: "First & Last Name",
                keyBoardType: TextInputType.name,
              ),
              if (_nameError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Text(
                    _nameError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              /////////////////////////////
              RoundTextField(
                controller: txtEmail,
                hintText: "Email Address",
                keyBoardType: TextInputType.emailAddress,
              ),
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Text(
                    _emailError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              /////////////////////////
              RoundTextField(
                controller: txtMobile,
                hintText: "Mobile Phone",
                keyBoardType: TextInputType.phone,
              ),
              if (_mobileError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Text(
                    _mobileError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              /////////////////////////
              RoundTextField(
                controller: txtCode,
                hintText: "Group Special Code (Optional)",
              ),
              const SizedBox(
                height: 15,
              ),
              /////////////////////////////
              RoundTextField(
                controller: txtPassword,
                hintText: "Password",
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Tcolor.subTitle.withOpacity(0.3),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              if (_passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Text(
                    _passwordError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              /////////////////////////////
              RoundTextField(
                controller: txtConfirmPassword,
                hintText: "Confirm Password",
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Tcolor.subTitle.withOpacity(0.3),
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
              if (_confirmPasswordError != null)
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 5),
                  child: Text(
                    _confirmPasswordError!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(
                height: 15,
              ),
              ////////////////////////
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isStay = !isStay;
                      });
                    },
                    icon: Icon(
                      isStay ? Icons.check_box : Icons.check_box_outline_blank,
                      color: isStay
                          ? Tcolor.primary
                          : Tcolor.subTitle.withOpacity(0.3),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "please sign me up for the monthly newsletter.",
                      style: TextStyle(
                        color: Tcolor.subTitle.withOpacity(0.3),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              ScaleInAnimation(
                delay: const Duration(milliseconds: 1200),
                child: RoundButton(
                  title: _isLoading ? "Creating Account..." : "Sign Up",
                  isEnabled: _isFormValid && !_isLoading,
                  isLoading: _isLoading,
                  onPressed: _isFormValid && !_isLoading ? _signUp : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
