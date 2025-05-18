import 'package:flutter/material.dart';

class Headings {
  static TextStyle mH1 = _base.copyWith(fontSize: 28, height: 32 / 28);
  static TextStyle mH2 = _base.copyWith(fontSize: 24, height: 32 / 24);
  static TextStyle mH3 = _base.copyWith(fontSize: 18, height: 24 / 18);
  static TextStyle mH4 = _base.copyWith(fontSize: 16, height: 24 / 16);
  static TextStyle mH5 = _base.copyWith(fontSize: 14, height: 20 / 14);
  static TextStyle mH6 = _base.copyWith(fontSize: 12, height: 16 / 12);

  static TextStyle h1 = _base.copyWith(fontSize: 60, height: 64 / 60);
  static TextStyle h2 = _base.copyWith(fontSize: 48, height: 56 / 48);
  static TextStyle h3 = _base.copyWith(fontSize: 36, height: 40 / 36);
  static TextStyle h4 = _base.copyWith(fontSize: 28, height: 32 / 28);
  static TextStyle h5 = _base.copyWith(fontSize: 24, height: 32 / 24);
  static TextStyle h6 = _base.copyWith(fontSize: 18, height: 24 / 18);
  static TextStyle h7 = _base.copyWith(fontSize: 16, height: 24 / 16);
  static TextStyle h8 = _base.copyWith(fontSize: 12, height: 16 / 12);

  static TextStyle get _base =>
      const TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0);
}

class Paragraphs {
  static TextStyle large = _base.copyWith(fontSize: 20, height: 32 / 20);
  static TextStyle largeSemiBold = large.copyWith(fontWeight: FontWeight.w600);

  static TextStyle medium = _base.copyWith(fontSize: 16, height: 24 / 16);
  static TextStyle mediumSemiBold = medium.copyWith(
    fontWeight: FontWeight.w600,
  );

  static TextStyle small = _base.copyWith(fontSize: 14, height: 20 / 14);
  static TextStyle smallSemiBold = small.copyWith(fontWeight: FontWeight.w600);

  static TextStyle disclaimer = _base.copyWith(fontSize: 12, height: 18 / 12);
  static TextStyle disclaimerSemiBold = disclaimer.copyWith(
    fontWeight: FontWeight.w600,
  );

  static TextStyle navigation = _base.copyWith(fontSize: 10, height: 16 / 10);

  static TextStyle get _base =>
      const TextStyle(fontWeight: FontWeight.w400, letterSpacing: 0);
}
