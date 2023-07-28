import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wanderlust_new/Themes/theme_model.dart';

import 'Database/database_helper.dart';
import 'Screens/splash_screen.dart';
import 'Themes/dark_theme.dart';
import 'Themes/light_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.getDatabase();
  await DatabaseHelper.instance.getalluser();

  runApp(
    ChangeNotifierProvider<ThemeModel>(
      create: (context) => ThemeModel(),
      child: const Wanderlust(),
    ),
  );
}

class Wanderlust extends StatelessWidget {
  const Wanderlust({super.key});

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
      themeMode: Provider.of<ThemeModel>(context).isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,
      home: const ValidationSplashScreen(),
    );
  }
}
