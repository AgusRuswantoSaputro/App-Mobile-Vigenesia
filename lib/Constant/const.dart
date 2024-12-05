import 'package:flutter/material.dart';

String url = "http://192.168.0.107:80/vigenesia/";//"https://429f-175-158-63-74.ngrok-free.app/vigenesia/";
// Change This For Different IP

final ThemeData lightTheme = ThemeData(
  
  //scaffoldBackgroundColor: Color.fromRGBO(13, 105, 105, 0.612),
  colorScheme: const ColorScheme.light(
    primary: Color.fromRGBO(255, 203, 59, 1),
    onPrimary: Color.fromARGB(255, 255, 0, 0),
    secondary: Color.fromARGB(255, 255, 56, 30),
    onSecondary: Color.fromARGB(255, 255, 255, 255),
    surface: Color.fromARGB(255, 255, 235, 235),
    onSurface: Color.fromARGB(255, 255, 89, 24),
    outline: Color.fromARGB(255, 255, 56, 30),
    brightness: Brightness.light,
    ),
  // Define additional light theme properties here
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  //scaffoldBackgroundColor: Color.fromRGBO(13, 105, 105, 0.612),
  colorScheme: const ColorScheme.dark(
    primary: Color.fromRGBO(255, 203, 59, 1),
    secondary: Color.fromARGB(255, 255, 56, 30),
    surface: Color.fromARGB(255, 61, 61, 61),
    onPrimary: Color.fromARGB(255, 255, 255, 255),
    onSecondary: Color.fromARGB(255, 26, 25, 25),
    onSurface: Color.fromARGB(255, 255, 89, 24),
    outline: Color.fromARGB(255, 255, 56, 30),
    

    ),
  // Define additional dark theme properties here
);

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;
  void setTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
