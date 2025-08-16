import 'package:flutter/material.dart';
import 'package:lib_ms/common/color__extention.dart';

class RoundTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyBoardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool hasBorder;

  const RoundTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyBoardType,
    this.suffixIcon,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Tcolor.textBox,
        borderRadius: BorderRadius.circular(20),
        border: hasBorder
            ? Border.all(
                color: Tcolor.subTitle.withOpacity(0.2),
                width: 1,
              )
            : null,
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyBoardType,
        obscureText: obscureText,
        style: TextStyle(
          color: Tcolor.text,
          fontSize: 15,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          focusedBorder: hasBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Tcolor.primary,
                    width: 2,
                  ),
                )
              : InputBorder.none,
          enabledBorder: hasBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Tcolor.subTitle.withOpacity(0.2),
                    width: 1,
                  ),
                )
              : InputBorder.none,
          errorBorder: hasBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                )
              : InputBorder.none,
          focusedErrorBorder: hasBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 2,
                  ),
                )
              : InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Tcolor.subTitle.withOpacity(0.5),
            fontSize: 15,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
