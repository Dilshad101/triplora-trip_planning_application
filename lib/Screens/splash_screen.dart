// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanderlust_new/database/database_helper.dart';

import '../models/user_model.dart';
import 'parent_screen.dart';
import 'welcom_screen.dart';

class ValidationSplashScreen extends StatefulWidget {
  const ValidationSplashScreen({super.key});

  @override
  State<ValidationSplashScreen> createState() => _ValidationSplashScreenState();
}

class _ValidationSplashScreenState extends State<ValidationSplashScreen> {
  UserModelClass? user;
  @override
  void initState() {
    super.initState();
    loginValidation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3C654D),
      body: Center(
        child: SvgPicture.asset(
          'svg_logo/triplora-logo.svg',
          height: 100,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }

  loginValidation() async {
    if (await DatabaseHelper.instance.checkLogin()) {
      user = await DatabaseHelper.instance.getLoggeduser();
      if (user != null) {}
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ScreenMain(
                loggedUser: user!,
              )));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ScreenWelcome()));
    }
  }
}
