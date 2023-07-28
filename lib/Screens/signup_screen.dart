// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wanderlust_new/Functionality/camara_bottomsheet.dart';

import '../Database/database_helper.dart';
import '../Database/database_models.dart';
import 'parent_screen.dart';
import 'signin_screen.dart';
import 'widgets/custom_textfield.dart';

class ScreenSignup extends StatefulWidget {
  const ScreenSignup({super.key});

  @override
  State<ScreenSignup> createState() => _ScreenSigninState();
}

class _ScreenSigninState extends State<ScreenSignup> {
  final usertextcontroller = TextEditingController();

  final passwordtextcontroller = TextEditingController();

  final confirmtextcontroller = TextEditingController();

  final emailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  late UserModelClass user;

  File? image;

  @override
  Widget build(BuildContext context) {
    final devicewidth = MediaQuery.of(context).size.width;
    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: SizedBox(
            height: deviceheight,
            child: Stack(
              children: [
                Column(
                  children: [
                    //background green container
                    Container(
                        height: 235, color: Theme.of(context).primaryColor),

                    // bottom logo
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.background,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'svg_logo/bottom-logo.svg',
                              height: 30,
                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),

                //Floating Card

                Positioned(
                  top: 77,
                  height: deviceheight / 1.2,
                  width: devicewidth,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 5,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4),
                      ),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  // Heading and profile
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Sign up',
                                        style: TextStyle(
                                            fontSize: 32,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      image == null
                                          ? CircleAvatar(
                                              radius: 25,
                                              backgroundColor: Colors.grey[300],
                                              child: Icon(
                                                  Icons.person_outline_rounded,
                                                  color: Colors.grey[600],
                                                  size: 29),
                                            )
                                          : CircleAvatar(
                                              radius: 25,
                                              backgroundImage:
                                                  FileImage(File(image!.path)),
                                            ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),

                                  //username input
                                  CustomTextField(
                                    controller: usertextcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Username required';
                                      } else if (usertextcontroller.text
                                          .trim()
                                          .isEmpty) {
                                        return 'Username required ';
                                      } else if (!DatabaseHelper.instance
                                          .isUsernameAvailable(value)) {
                                        return 'This username is already taken';
                                      }
                                      return null;
                                    },
                                    label: 'Username',
                                  ),

                                  const SizedBox(
                                    height: 25,
                                  ),

                                  //Email input

                                  CustomTextField(
                                      controller: emailcontroller,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'provide necessory information';
                                        } else if (!isEmailValid(value)) {
                                          return 'invalid email format.';
                                        }
                                        return null;
                                      },
                                      label: 'Enter your Email address'),

                                  // Space

                                  const SizedBox(
                                    height: 25,
                                  ),

                                  //password input

                                  CustomPasswordField(
                                    label: 'password',
                                    passcontroller: passwordtextcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Password required';
                                      } else if (value.length != 8) {
                                        return 'password require 8  charecters';
                                      } else if (!value
                                          .contains(RegExp(r'[a-z]'))) {
                                        return 'Password must contain a letter';
                                      } else if (!value
                                          .contains(RegExp(r'[0-9]'))) {
                                        return 'Password must contain a digit';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  //confirm password input

                                  CustomPasswordField(
                                    label: 'confirm password',
                                    passcontroller: confirmtextcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'confirm your password';
                                      } else if (value.length != 8) {
                                        return 'password require 8 charecters';
                                      } else if (passwordtextcontroller.text
                                              .trim() !=
                                          confirmtextcontroller.text.trim()) {
                                        return 'password does not match';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 20),

                                  //image button

                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onBackground),
                                        fixedSize: MaterialStateProperty.all(
                                            const Size(double.maxFinite, 48))),
                                    onPressed:
                                        showImagePickerBottomSheet, //addimage,
                                    child: const Text('Upload Profile photo',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                                  const SizedBox(height: 15),

                                  //Signup button

                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context).primaryColor),
                                        fixedSize: MaterialStateProperty.all(
                                            const Size(double.maxFinite, 48))),
                                    onPressed: adduserprofile,
                                    child: const Text('Sign up',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white)),
                                  ),

                                  // signin text

                                  Expanded(
                                    child: InkWell(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Already have an account ',
                                              style: TextStyle(
                                                color: Color(0xFF888888),
                                                fontSize: 12,
                                              )),
                                          Text(
                                            'Sign in',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              fontSize: 12,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationStyle:
                                                  TextDecorationStyle.solid,
                                              decorationColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              decorationThickness: 2,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ScreenLogin()));
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

//  bottom sheet for image picking//
  showImagePickerBottomSheet() {
    showImageBottomSheet(
        context: context,
        camara: () {
          addimage(camera: true);
          Navigator.of(context).pop();
        },
        galary: () {
          addimage(camera: false);
          Navigator.of(context).pop();
        });
  }

  // user validation
  adduserprofile() async {
    await DatabaseHelper.instance
        .usernameAvailable(usertextcontroller.text.trim());
    // Image validation

    if (image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          margin: EdgeInsets.all(10),
          content: Center(child: Text('Please select a profile photo'))));
      return;
    }
    //Form submit validation
    if (_formkey.currentState!.validate()) {
      if (usertextcontroller.text.isEmpty ||
          passwordtextcontroller.text.isEmpty ||
          confirmtextcontroller.text.isEmpty ||
          emailcontroller.text.isEmpty ||
          image == null) {
        return;
      }

      // adding user to database

      String username = usertextcontroller.text.trim();
      String password = passwordtextcontroller.text.trim();
      String imagepath = image!.path;
      String email = emailcontroller.text.trim();

      user = UserModelClass(
        username: username,
        email: email,
        password: password,
        imagepath: imagepath,
        isLogedin: 1,
      );
      DatabaseHelper.instance.adduser(user);
      final loggeduser = await DatabaseHelper.instance.getLoggeduser();
      // adduser(user);
      // getalluser();

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ScreenMain(
                loggedUser: loggeduser,
              )));
    }
  }

  // image adding function

  addimage({required bool camera}) async {
    final pickedimage = await ImagePicker().pickImage(
        source: camera == true ? ImageSource.camera : ImageSource.gallery);
    if (pickedimage == null) {
      return;
    }
    setState(() {
      image = File(pickedimage.path);
    });
  }
}

//Email validation
bool isEmailValid(String email) {
  // Regular expression pattern for email validation
  String pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(email);
}

// //Password validation
// bool isvalidatePassword(String password) {
//   // Password must be at least 8 characters long
//   if (password.length < 8) {
//     return false;
//   }

//   // Password must contain at least one lowercase letter
//   if (!password.contains(RegExp(r'[a-z]'))) {
//     return false;
//   }

//   // Password must contain at least one digit
//   if (!password.contains(RegExp(r'[0-9]'))) {
//     return false;
//   }

//   return true;
// }
