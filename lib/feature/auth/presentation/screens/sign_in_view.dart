import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/common_widget/round_button.dart';
import 'package:lib_ms/common_widget/round_textfield.dart';
import 'package:lib_ms/view/main_tab/main_tab_view.dart';
import 'package:lib_ms/common/page_transitions.dart';
import 'package:lib_ms/common/animated_widgets.dart';
import 'package:lib_ms/view/login/forgot_password_view.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SignInView> {
  final TextEditingController txtCode = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  bool isStay = false;
  bool _isAuthor = false;
  bool _isFormValid = false;
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
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

  bool _isValidEmail(String email) =>
      RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email);

  bool _isValidPassword(String password) => password.length >= 6;

  void _validateForm() {
    final email = txtEmail.text.trim();
    final password = txtPassword.text;

    setState(() {
      _emailError = email.isEmpty
          ? null
          : (_isValidEmail(email) ? null : 'Please enter a valid email address');

      _passwordError = password.isEmpty
          ? null
          : (_isValidPassword(password) ? null : 'Password must be at least 6 characters');

      _isFormValid = email.isNotEmpty &&
          password.isNotEmpty &&
          _emailError == null &&
          _passwordError == null;
    });
  }

  void _signIn() {
    if (!_isFormValid || _isLoading) return;
    FocusScope.of(context).unfocus();

    context.read<AuthBloc>().add(SignInRequested(
      email: txtEmail.text.trim(),
      password: txtPassword.text,
      rememberMe: isStay,
      isAuthor: _isAuthor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: (context, state) {
        setState(() => _isLoading = state is AuthLoading);

        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacement(
            FadePageRoute(
              child: const MainTabView(),
              duration: const Duration(milliseconds: 500),
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
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
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                SlideInAnimation(
                  delay: const Duration(milliseconds: 400),
                  begin: const Offset(0.0, 0.5),
                  child: RoundTextField(
                    controller: txtCode,
                    hintText: "Group Special Code (Optional)",
                  ),
                ),
                const SizedBox(height: 15),

                // Email
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
                  const SizedBox(height: 5),
                if (_emailError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(_emailError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),

                const SizedBox(height: 15),

                // Password
                SlideInAnimation(
                  delay: const Duration(milliseconds: 800),
                  begin: const Offset(0.0, 0.5),
                  child: RoundTextField(
                    controller: txtPassword,
                    hintText: "Password",
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Tcolor.subTitle.withOpacity(0.3),
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                if (_passwordError != null)
                  const SizedBox(height: 5),
                if (_passwordError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(_passwordError!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),

                const SizedBox(height: 15),

                // Stay logged in / Forgot password
                Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => _isAuthor = !_isAuthor),
                      icon: Icon(
                        _isAuthor ? Icons.check_box : Icons.check_box_outline_blank,
                        color: _isAuthor ? Tcolor.primary : Tcolor.subTitle.withOpacity(0.3),
                      ),
                    ),
                    Text(
                      "Login as Author",
                      style: TextStyle(color: Tcolor.subTitle.withOpacity(0.3), fontSize: 15),
                    ),

                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordView()),
                        );
                      },
                      child: Text(
                        "Forget Your Password",
                        style: TextStyle(color: Tcolor.subTitle.withOpacity(0.3), fontSize: 15),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Submit
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
      ),
    );
  }
}
