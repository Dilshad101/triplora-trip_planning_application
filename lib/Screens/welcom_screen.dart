// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import 'signin_screen.dart';
import 'signup_screen.dart';

class ScreenWelcome extends StatelessWidget {
  const ScreenWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (Rect bounds) {
                  return LinearGradient(
                    colors: [
                      Colors.transparent,
                      Theme.of(context).colorScheme.background
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds);
                },
                child: SizedBox(
                    width: double.infinity,
                    child: Image.asset(
                      'assets/spashcover.jpg',
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 35),
                    SvgPicture.asset(
                      'svg_logo/wanderlust-logo.svg',
                      height: 90,
                      colorFilter: ColorFilter.mode(
                          Theme.of(context).colorScheme.primary.withOpacity(.5),
                          BlendMode.srcIn),
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              fixedSize: MaterialStateProperty.all(
                                  const Size.fromHeight(48)),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).colorScheme.primary),
                            ),
                            onPressed: () async {
                              if (await isPermissionGranted(context)) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ScreenLogin()));
                              }
                            },
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ))),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                            style: ButtonStyle(
                                fixedSize: MaterialStateProperty.all(
                                    const Size.fromHeight(48)),
                                side: MaterialStateProperty.all(BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary))),
                            onPressed: () async {
                              if (await isPermissionGranted(context)) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ScreenSignup()));
                              }
                            },
                            child: Text(
                              'Singup',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary),
                            ))),
                    const SizedBox(
                      height: 25,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> isPermissionGranted(context) async {
    if (!await Permission.camera.request().isGranted) {
      return false;
    }
    if (!await Permission.storage.request().isGranted) {
      return false;
    }
    if (!await Permission.camera.request().isGranted) {
      return false;
    }
    return true;
  }
}
