// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wanderlust_new/Database/database_helper.dart';

import 'parent_screen.dart';
import 'signup_screen.dart';
import 'widgets/custom_textfield.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({super.key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final usercontroller = TextEditingController();

  final passcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).height;

    return Scaffold(
        // backgroundColor: Colors.grey.shade100,
        body: SizedBox(
      height: size,
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: size / 2,
                  child: ShaderMask(
                    blendMode: BlendMode.srcATop,
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Theme.of(context).colorScheme.background
                        ], // Replace with your desired colors
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ).createShader(bounds);
                    },

                    //Login conver photo

                    child: SizedBox(
                        width: double.infinity,
                        child: Image.asset(
                          'assets/travelbag.jpg',
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: size / 2,
                  width: double.infinity,
                  child: Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sign in',
                            style: TextStyle(
                              fontSize: 32,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            )),
                        const SizedBox(
                          height: 26,
                        ),

                        // username field

                        CustomTextField(
                            controller: usercontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username required';
                              } else if (usercontroller.text.trim().isEmpty) {
                                return 'Username required ';
                              }
                              return null;
                            },
                            label: 'Username'),
                        const SizedBox(
                          height: 26,
                        ),

                        // Password Field
                        CustomPasswordField(
                          label: 'Password',
                          passcontroller: passcontroller,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password required';
                            } else if (value.length != 8) {
                              return 'password require 8  charecters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        //Submit button

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: signinValidation,
                            child: const Text('Sign in'),
                          ),
                        ),
                        const SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ScreenSignup()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account ',
                                style: TextStyle(
                                    fontSize: 12, color: Color(0xFF888888)),
                              ),
                              Text(
                                'Sign up',
                                style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 17,
                        ),
                        Center(
                          child: SvgPicture.asset(
                            'svg_logo/bottom-logo.svg',
                            height: 22,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            //positioned welcome text

            Positioned(
              top: 50,
              left: 20,
              child: Text(
                'Welcome\nBack',
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.white.withOpacity(0.6),
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    ));
  }

  signinValidation() async {
    if (_formkey.currentState!.validate()) {
      String username = usercontroller.text.trim();
      String password = passcontroller.text.trim();

      if (await DatabaseHelper.instance.validating(username, password)) {
        final user = await DatabaseHelper.instance.authentication(username);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ScreenMain(
                  loggedUser: user,
                )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Color(0xFFFF1C1C),
            content: Center(
                child: Text(
              'Username and password does not match',
              style: TextStyle(fontSize: 13),
            )),
          ),
        );
      }
    }
  }
}
