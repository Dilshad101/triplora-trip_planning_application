import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wanderlust_new/utils/themes/theme_provider.dart';

import 'database/database_helper.dart';
import 'screens/splash_screen.dart';
import 'utils/themes/dark_theme.dart';
import 'utils/themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.getDatabase();
  await DatabaseHelper.instance.getalluser();

  runApp(
    ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: const TriploraApp(),
    ),
  );
}

class TriploraApp extends StatelessWidget {
  const TriploraApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const ValidationSplashScreen(),
    );
  }
}
