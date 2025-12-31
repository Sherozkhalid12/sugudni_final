import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Safe wrapper for GoogleFonts that handles exceptions gracefully
class SafeGoogleFonts {
  /// Safely get a TextStyle using GoogleFonts with fallback to default font
  static TextStyle safeTextStyle({
    required String fontFamily,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextStyle? fallbackStyle,
  }) {
    try {
      switch (fontFamily.toLowerCase()) {
        case 'roboto':
          return GoogleFonts.roboto(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          );
        case 'blinker':
          return GoogleFonts.blinker(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          );
        case 'raleway':
          return GoogleFonts.raleway(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          );
        case 'nunitosans':
          return GoogleFonts.nunitoSans(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          );
        case 'julee':
          return GoogleFonts.julee(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          );
        case 'shrikhand':
          return GoogleFonts.shrikhand(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          );
        default:
          return fallbackStyle ?? TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
          );
      }
    } catch (e) {
      // If GoogleFonts fails, return fallback style
      return fallbackStyle ?? TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    }
  }
  
  /// Safely get Roboto font
  static TextStyle roboto({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return safeTextStyle(
      fontFamily: 'roboto',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fallbackStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: 'Roboto',
      ),
    );
  }
  
  /// Safely get Blinker font
  static TextStyle blinker({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return safeTextStyle(
      fontFamily: 'blinker',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fallbackStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
  
  /// Safely get Raleway font
  static TextStyle raleway({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return safeTextStyle(
      fontFamily: 'raleway',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fallbackStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
  
  /// Safely get NunitoSans font
  static TextStyle nunitoSans({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return safeTextStyle(
      fontFamily: 'nunitosans',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fallbackStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
  
  /// Safely get Julee font
  static TextStyle julee({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return safeTextStyle(
      fontFamily: 'julee',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fallbackStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
  
  /// Safely get Shrikhand font
  static TextStyle shrikhand({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return safeTextStyle(
      fontFamily: 'shrikhand',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fallbackStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

