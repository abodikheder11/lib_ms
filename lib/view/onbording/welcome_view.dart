import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/common_widget/round_button.dart';
import 'package:lib_ms/feature/auth/presentation/screens/sign_up_view.dart';
import 'package:lib_ms/feature/auth/presentation/screens/sign_in_view.dart';
import 'package:lib_ms/common/page_transitions.dart';
import 'package:lib_ms/common/animated_widgets.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "assets/images/0.jpg",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Container(
              width: media.width,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(
                    height: media.width * 0.25,
                  ),
                  FadeInAnimation(
                    delay: const Duration(milliseconds: 500),
                    child: Text(
                      "Books For\nEvery Taste",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Tcolor.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.28,
                  ),
                  /////////////////////
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 800),
                    begin: const Offset(0.0, 1.0),
                    child: RoundButton(
                      title: "Sign in",
                      onPressed: () {
                        Navigator.of(context).pushSlide(
                          const SignInView(),
                          direction: SlideDirection.rightToLeft,
                        );
                      },
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  /////////////////////////
                  SlideInAnimation(
                    delay: const Duration(milliseconds: 1000),
                    begin: const Offset(0.0, 1.0),
                    child: RoundButton(
                      title: "Sign up",
                      onPressed: () {
                        Navigator.of(context).pushSlide(
                          const SignUpView(),
                          direction: SlideDirection.rightToLeft,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
