import 'package:flutter/material.dart';
import 'package:portal/Screens/Login.dart';
import 'Screens/MainScreens.dart';

class GlobalThemData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

static ThemeData lightThemeData =
      themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      canvasColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      highlightColor: Colors.transparent,
      focusColor: focusColor
    );
  }
  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color.fromRGBO(255, 203, 59, 1),
    onPrimary: Color.fromARGB(255, 255, 0, 0),
    secondary: Color.fromARGB(255, 255, 56, 30),
    onSecondary: Color.fromARGB(255, 255, 255, 255),
    error: Color.fromARGB(255, 255, 117, 82),
    onError: Color.fromARGB(255, 255, 0, 0),
    surface: Color.fromARGB(255, 255, 249, 248),
    onSurface: Color.fromARGB(255, 255, 89, 24),
    brightness: Brightness.light,
  );
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color.fromRGBO(255, 203, 59, 1),
    secondary: Color.fromARGB(255, 255, 56, 30),
    surface: Color.fromARGB(255, 14, 13, 13),
    error: Color.fromARGB(255, 255, 117, 82),
    onError: Color.fromARGB(255, 255, 0, 0),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Color.fromARGB(255, 255, 89, 24),
    brightness: Brightness.dark,
  );
}

void main() => runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    ));

