import 'package:flutter/material.dart';

extension CommonExtention on State {
  void endEditing() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
