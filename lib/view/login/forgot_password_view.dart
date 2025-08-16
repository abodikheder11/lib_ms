import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';
import 'package:lib_ms/common_widget/round_button.dart';
import 'package:lib_ms/common_widget/round_textfield.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _SigninViewState();
}

class _SigninViewState extends State<ForgotPasswordView> {
  TextEditingController txtEmail = TextEditingController();

  bool isStay = false;

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
                "Forgot Password",
                style: TextStyle(
                    color: Tcolor.text,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
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
              const SizedBox(
                height: 15,
              ),
              //////////////////
              RoundLineButton(title: "Submit", onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}
