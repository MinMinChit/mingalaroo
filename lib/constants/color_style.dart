import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KStyle {
  static Color cPrimary = Color(0xFF16130E);
  static Color cBrand = Color(0xFFFFB832);
  static Color cWhite = Color(0xFFFFFFFF);
  static Color cBlack = Color(0xFF000000);

  static Color cBg1 = Color(0xFFFAFAFA);
  static Color cBg2 = Color(0xFFF5F5F5);

  static Color cStroke = Color(0xFFE6E6E6);
  static Color cDisable = Color(0xFFC8C8C8);
  static Color cSecondaryText = Color(0xFF7D7D7D);
  static Color cPrimaryText = Color(0xFF18272C);

  static Color cError = Color(0xFFDC1717);
  static Color cWarning = Color(0xFFFDCF36);
  static Color cSuccess = Color(0xFF43C40B);
  static Color cLink = Color(0xFF1270DB);

  static TextStyle tTitleXXL = GoogleFonts.inriaSerif(
    textStyle: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: KStyle.cPrimaryText,
    ),
  );

  static TextStyle tTitleXL = GoogleFonts.inriaSerif(
    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: KStyle.cPrimaryText,
    ),
  );

  static TextStyle tTitleL = GoogleFonts.inriaSerif(
    textStyle: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: KStyle.cPrimaryText,
    ),
  );

  static TextStyle tTitleM = GoogleFonts.inriaSerif(
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: KStyle.cPrimaryText,
    ),
  );

    static TextStyle tTitleS = GoogleFonts.inriaSerif(
    textStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      color: KStyle.cPrimaryText,
    ),
  );

  static TextStyle tBodyL = GoogleFonts.inter(
    textStyle: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: KStyle.cPrimaryText,
    ),
  );
  static TextStyle tBodyM = GoogleFonts.inter(
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: KStyle.cPrimaryText,
    ),
  );

  static TextStyle tBodyS = GoogleFonts.inter(
    textStyle: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.normal,
      color: KStyle.cPrimaryText,
    ),
  );
}
