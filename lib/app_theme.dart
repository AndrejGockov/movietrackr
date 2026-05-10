import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme{
  AppTheme._();

  // ================
  //      SPACING
  // ================
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // ================
  //      PADDING
  // ================
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  // ================
  //      COLORS
  // ================
  static const Color lightBlue = Color(0xFF82A0B9);
  static const Color mediumBlue = Color(0xFF2E457D);
  static const Color darkBlue = Color(0xFF272652);
  static const Color deepBlue = Color(0xFF111227);

  // Text Colors
  static const Color textOnMediumBlue = Color(0xFFF5F9FF);
  static const Color textOnDarkBlue = Color(0xFFF0F4FF);
  static const Color textOnDeepBlue = Color(0xFFE8EDFF);

  // Red & Green
  static const Color primaryRed = Color(0xFFE63E3E);
  static const Color primaryYellow = Color(0xFFE6B800);
  static const Color primaryGreen = Color(0xFF3F9E4D);

  static const Color linkPrimary = Color(0xFF7BB3E0);
  static const Color linkSecondary = Color(0xFF5D9BC7);
  static const Color linkTertiary = Color(0xFF9BB8D5);
  static const Color linkHover = Color(0xFFA3C8ED);

  // ================
  //      FONTS
  // ================
  // For mediumBlue background
  static TextStyle h1SemiboldOnMediumBlue = GoogleFonts.montserrat(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: textOnMediumBlue,
  );
  static TextStyle h2SemiboldOnMediumBlue = GoogleFonts.montserrat(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textOnMediumBlue,
  );
  static TextStyle h3SemiboldOnMediumBlue = GoogleFonts.montserrat(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textOnMediumBlue,
  );
  static TextStyle h4SemiboldOnMediumBlue = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textOnMediumBlue,
  );
  static TextStyle h5SemiboldOnMediumBlue = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: textOnMediumBlue,
  );
  static TextStyle h6SemiboldOnMediumBlue = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: textOnMediumBlue,
  );
  static TextStyle h7SemiboldOnMediumBlue = GoogleFonts.montserrat(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    color: textOnMediumBlue,
  );

  static TextStyle h4SemiboldPrimaryRed = GoogleFonts.montserrat(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: primaryRed,
  );

  static TextStyle h6SemiboldPrimaryRed = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: primaryRed,
  );

  static TextStyle h6SemiboldPrimaryYellow = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: primaryYellow,
  );

  static TextStyle h6SemiboldPrimaryGreen = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: primaryGreen,
  );

  static TextStyle h5SemiboldLinkSecondary = GoogleFonts.montserrat(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: linkSecondary,
  );

  static TextStyle h6SemiboldLinkSecondary = GoogleFonts.montserrat(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: linkSecondary,
  );

  // // For darkBlue background
  // static TextStyle h1SemiboldOnDarkBlue = GoogleFonts.montserrat(
  //   fontSize: 28,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDarkBlue,
  // );
  // static TextStyle h2SemiboldOnDarkBlue = GoogleFonts.montserrat(
  //   fontSize: 24,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDarkBlue,
  // );
  // static TextStyle h3SemiboldOnDarkBlue = GoogleFonts.montserrat(
  //   fontSize: 18,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDarkBlue,
  // );
  // static TextStyle h4SemiboldOnDarkBlue = GoogleFonts.montserrat(
  //   fontSize: 16,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDarkBlue,
  // );
  // static TextStyle h5SemiboldOnDarkBlue = GoogleFonts.montserrat(
  //   fontSize: 14,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDarkBlue,
  // );
  // static TextStyle h6SemiboldOnDarkBlue = GoogleFonts.montserrat(
  //   fontSize: 12,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDarkBlue,
  // );
  // static TextStyle h7SemiboldOnDarkBlue = GoogleFonts.montserrat(
  //   fontSize: 10,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDarkBlue,
  // );
  //
  // // For deepBlue background
  // static TextStyle h1SemiboldOnDeepBlue = GoogleFonts.montserrat(
  //   fontSize: 28,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDeepBlue,
  // );
  // static TextStyle h2SemiboldOnDeepBlue = GoogleFonts.montserrat(
  //   fontSize: 24,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDeepBlue,
  // );
  // static TextStyle h3SemiboldOnDeepBlue = GoogleFonts.montserrat(
  //   fontSize: 18,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDeepBlue,
  // );
  // static TextStyle h4SemiboldOnDeepBlue = GoogleFonts.montserrat(
  //   fontSize: 16,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDeepBlue,
  // );
  // static TextStyle h5SemiboldOnDeepBlue = GoogleFonts.montserrat(
  //   fontSize: 14,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDeepBlue,
  // );
  // static TextStyle h6SemiboldOnDeepBlue = GoogleFonts.montserrat(
  //   fontSize: 12,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDeepBlue,
  // );
  // static TextStyle h7SemiboldOnDeepBlue = GoogleFonts.montserrat(
  //   fontSize: 10,
  //   fontWeight: FontWeight.w600,
  //   color: textOnDeepBlue,
  // );
}