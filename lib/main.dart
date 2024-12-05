import 'package:flutter/material.dart';
import 'Screens/Register.dart';
import 'Screens/Login.dart';
import 'package:provider/provider.dart';
import 'Screens/MainScreens.dart';
import '/../Constant/const.dart';
import 'Screens/EditPage.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) =>ThemeNotifier(),
  child: const MyApp())
    );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeNotifier.themeMode,
          home: const MainScreens(),
        );
      },
    );
  }
}