import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/common_widget/round_button.dart';
import 'package:lib_ms/common_widget/round_textfield.dart';
import 'package:lib_ms/common/page_transitions.dart';
import 'package:lib_ms/common/animated_widgets.dart';
import 'package:lib_ms/feature/auth/presentation/bloc/auth_bloc.dart';
import 'package:lib_ms/view/main_tab/main_tab_view.dart';

import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'erify_email_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtEmail = TextEditingController();
  final txtLocation = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConfirmPassword = TextEditingController();
  final  txtCode = TextEditingController();
  bool _isAuthor = false;
  bool isStay = false;
  bool _isFormValid = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _nameError;
  String? _emailError;
  String? _locationError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void initState() {
    super.initState();
    txtFirstName.addListener(_validateForm);
    txtLastName.addListener(_validateForm);
    txtEmail.addListener(_validateForm);
    txtLocation.addListener(_validateForm);
    txtPassword.addListener(_validateForm);
    txtConfirmPassword.addListener(_validateForm);

  }

  @override
  void dispose() {
    txtFirstName.dispose();
    txtLastName.dispose();
    txtEmail.dispose();
    txtLocation.dispose();
    txtPassword.dispose();
    txtConfirmPassword.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) => password.length >= 6;

  bool _isValidName(String name) =>
      name.trim().length >= 2 && RegExp(r'^[a-zA-Z\s]+$').hasMatch(name);

  void _validateForm() {
    setState(() {
      final name = txtFirstName.text.trim();
      final email = txtEmail.text.trim();
      final location = txtLocation.text.trim();
      final password = txtPassword.text.trim();
      final confirmPassword = txtConfirmPassword.text.trim();



      _nameError =
      name.isNotEmpty && !_isValidName(name) ? "Enter valid name" : null;
      _emailError =
      email.isNotEmpty && !_isValidEmail(email) ? "Enter valid email" : null;
      _locationError =
      location.isEmpty ? "Location is required" : null;
      _passwordError = password.isNotEmpty && !_isValidPassword(password)
          ? "Min 6 characters"
          : null;
      _confirmPasswordError =
      confirmPassword.isNotEmpty && confirmPassword != password
          ? "Passwords do not match"
          : null;

      _isFormValid = name.isNotEmpty &&
          email.isNotEmpty &&
          location.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          _nameError == null &&
          _emailError == null &&
          _locationError == null &&
          _passwordError == null &&
          _confirmPasswordError == null;
    });
  }

  void _signUp() {
    if (!_isFormValid) return;
    context.read<AuthBloc>().add(SignUpRequested(
      firstname: txtFirstName.text.trim(),
      lastname: txtLastName.text.trim(),
      email: txtEmail.text.trim(),
      location: txtLocation.text.trim(),
      password: txtPassword.text.trim(),
      passwordConfirmation: txtConfirmPassword.text.trim(),
      isAuthor: _isAuthor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.of(context).pushReplacement(
            FadePageRoute(child: const MainTabView()),
          );
        } else if (state is AuthUnverified) {
          Navigator.of(context).pushReplacement(
            FadePageRoute(child: VerifyEmailView(email: state.email)),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
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
                  Text("Sign Up",
                      style: TextStyle(
                          color: Tcolor.text,
                          fontSize: 24,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),


                  RoundTextField(
                    controller: txtFirstName,
                    hintText: "First Name",
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
                  const SizedBox(height: 15),
                  RoundTextField(controller: txtLastName, hintText: "Last Name"),
                  const SizedBox(height: 15),

                  RoundTextField(
                      controller: txtEmail,
                      hintText: "Email Address",
                      keyBoardType: TextInputType.emailAddress),
                  if (_emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 5),
                      child: Text(_emailError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  const SizedBox(height: 15),

                  RoundTextField(controller: txtLocation, hintText: "Location"),
                  if (_locationError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 5),
                      child: Text(_locationError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  const SizedBox(height: 15),

                  RoundTextField(
                    controller: txtCode,
                    hintText: "Group Special Code (Optional)",
                  ),
                  const SizedBox(height: 15),
                  RoundTextField(
                    controller: txtPassword,
                    hintText: "Password",
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Tcolor.subTitle.withOpacity(0.3)),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  if (_passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 5),
                      child: Text(_passwordError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  const SizedBox(height: 15),

                  RoundTextField(
                    controller: txtConfirmPassword,
                    hintText: "Confirm Password",
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Tcolor.subTitle.withOpacity(0.3)),
                      onPressed: () => setState(
                              () => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                  if (_confirmPasswordError != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 5),
                      child: Text(_confirmPasswordError!,
                          style: const TextStyle(color: Colors.red, fontSize: 12)),
                    ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _isAuthor = !_isAuthor),
                        icon: Icon(
                          _isAuthor ? Icons.check_box : Icons.check_box_outline_blank,
                          color: _isAuthor ? Tcolor.primary : Tcolor.subTitle.withOpacity(0.3),
                        ),
                      ),
                      const Text("Register as Author"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  ScaleInAnimation(
                    delay: const Duration(milliseconds: 1200),
                    child: RoundButton(
                      title: isLoading ? "Creating Account..." : "Sign Up",
                      isEnabled: _isFormValid && !isLoading,
                      isLoading: isLoading,
                      onPressed: _isFormValid && !isLoading ? _signUp : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
