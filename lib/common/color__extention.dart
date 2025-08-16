import 'package:flutter/material.dart';

class Tcolor {
  static Color get primary => const Color(0xff5ABD8C);
  static Color get primaryLight => const Color(0xffAfDfC7);
  static Color get text => const Color(0xff212121);
  static Color get subTitle => const Color(0xff212121).withOpacity(0.4);

  static Color get color1 => const Color(0xff1C4A7E);
  static Color get color2 => const Color.fromARGB(255, 212, 108, 39);
  static Color get color3 => const Color.fromARGB(255, 101, 197, 216);

  static Color get dColor => const Color(0xffF3F3F3);

  static Color get textBox => const Color.fromARGB(0, 131, 130, 130);
  static List<Color> get button => const [Color(0xff5abd8c), Color(0xff00ff81)];
  static List<Color> get listView =>
      const [Color(0xff5abd8c), Color(0xff00ff81)];

  static List<Color> get searchBGColor => const [
        Color(0xffb7143c),
        Color(0xffe6a508),
        Color(0xffef4c45),
        Color(0xfff46417),
        Color(0xff09ade2),
        Color(0xffd36a43),
      ];
}
