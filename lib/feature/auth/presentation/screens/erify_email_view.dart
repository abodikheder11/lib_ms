import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/common_widget/round_button.dart';
import 'package:lib_ms/common_widget/round_textfield.dart';
import 'package:lib_ms/common/animated_widgets.dart';
import 'package:lib_ms/view/main_tab/main_tab_view.dart';
import 'package:lib_ms/common/page_transitions.dart';

class VerifyEmailView extends StatefulWidget {
  final String email;

  const VerifyEmailView({super.key, required this.email});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  TextEditingController txtCode = TextEditingController();
  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    txtCode.addListener(_validateForm);
  }

  @override
  void dispose() {
    txtCode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = txtCode.text.trim().length >= 4; // assume 4+ digit code
    });
  }

  Future<void> _verify() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    try {
      // 🔹 TODO: call your API with txtCode + widget.email
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
            content: Text('Verification failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Tcolor.primary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeInAnimation(
              delay: const Duration(milliseconds: 200),
              child: Text(
                "Verify Your Email",
                style: TextStyle(
                  color: Tcolor.text,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "We’ve sent a verification code to:",
              style: TextStyle(
                color: Tcolor.subTitle.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.email,
              style: TextStyle(
                color: Tcolor.primary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 30),

            SlideInAnimation(
              delay: const Duration(milliseconds: 400),
              begin: const Offset(0.0, 0.5),
              child: RoundTextField(
                controller: txtCode,
                hintText: "Enter Verification Code",
                keyBoardType: TextInputType.number,
              ),
            ),
            const SizedBox(height: 20),

            ScaleInAnimation(
              delay: const Duration(milliseconds: 600),
              child: RoundButton(
                title: _isLoading ? "Verifying..." : "Verify",
                isEnabled: _isFormValid && !_isLoading,
                isLoading: _isLoading,
                onPressed: _isFormValid && !_isLoading ? _verify : null,
              ),
            ),

            const SizedBox(height: 15),

            Center(
              child: TextButton(
                onPressed: () {
                  // 🔹 TODO: implement resend code API
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Verification code resent!")),
                  );
                },
                child: Text(
                  "Resend Code",
                  style: TextStyle(color: Tcolor.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
