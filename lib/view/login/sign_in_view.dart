import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/common_widget/round_button.dart';
import 'package:lib_ms/common_widget/round_textfield.dart';
import 'package:lib_ms/view/main_tab/main_tab_view.dart';
import 'package:lib_ms/common/page_transitions.dart';
import 'package:lib_ms/common/animated_widgets.dart';
import 'package:lib_ms/view/login/forgot_password_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SignInView> {
  TextEditingController txtCode = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isStay = false;
  bool _isFormValid = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    // Add listeners to text controllers
    txtEmail.addListener(_validateForm);
    txtPassword.addListener(_validateForm);
  }

  @override
  void dispose() {
    txtCode.dispose();
    txtEmail.dispose();
    txtPassword.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }

  void _validateForm() {
    setState(() {
      final email = txtEmail.text.trim();
      final password = txtPassword.text.trim();

      // Email validation
      if (email.isEmpty) {
        _emailError = null;
      } else if (!_isValidEmail(email)) {
        _emailError = "Please enter a valid email address";
      } else {
        _emailError = null;
      }

      // Password validation
      if (password.isEmpty) {
        _passwordError = null;
      } else if (!_isValidPassword(password)) {
        _passwordError = "Password must be at least 6 characters";
      } else {
        _passwordError = null;
      }

      _isFormValid = email.isNotEmpty &&
          password.isNotEmpty &&
          _emailError == null &&
          _passwordError == null;
    });
  }

  Future<void> _signIn() async {
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
            content: Text('Sign in failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
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
              FadeInAnimation(
                delay: const Duration(milliseconds: 200),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Tcolor.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SlideInAnimation(
                delay: const Duration(milliseconds: 400),
                begin: const Offset(0.0, 0.5),
                child: RoundTextField(
                  controller: txtCode,
                  hintText: "Group Special Code (Optional)",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              /////////////////////////////
              SlideInAnimation(
                delay: const Duration(milliseconds: 600),
                begin: const Offset(0.0, 0.5),
                child: RoundTextField(
                  controller: txtEmail,
                  hintText: "Email Address",
                  keyBoardType: TextInputType.emailAddress,
                ),
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
              SlideInAnimation(
                delay: const Duration(milliseconds: 800),
                begin: const Offset(0.0, 0.5),
                child: RoundTextField(
                  controller: txtPassword,
                  hintText: "Password",
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Tcolor.subTitle.withOpacity(0.3),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
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
                  Text(
                    "Stay Logged In",
                    style: TextStyle(
                      color: Tcolor.subTitle.withOpacity(0.3),
                      fontSize: 15,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordView()));
                    },
                    child: Text(
                      "Forget Your Password",
                      style: TextStyle(
                        color: Tcolor.subTitle.withOpacity(0.3),
                        fontSize: 15,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              ScaleInAnimation(
                delay: const Duration(milliseconds: 1000),
                child: RoundButton(
                  title: _isLoading ? "Signing In..." : "Sign In",
                  isEnabled: _isFormValid && !_isLoading,
                  isLoading: _isLoading,
                  onPressed: _isFormValid && !_isLoading ? _signIn : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
