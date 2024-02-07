import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wanderlust_new/database/database_helper.dart';
import 'package:wanderlust_new/screens/parent_screen.dart';
import 'package:wanderlust_new/screens/signup_screen.dart';

import '../models/user_model.dart';
import '../utils/functions/camara_bottomsheet.dart';
import '../utils/functions/image_picker_function.dart';
import '../utils/messages/flush_bar.dart';
import '../widgets/custom_listtile.dart';
import '../widgets/custom_textfield.dart';

class ScreenAccountInfo extends StatefulWidget {
  const ScreenAccountInfo({super.key, required this.loggeduser});

  final UserModelClass loggeduser;

  @override
  State<ScreenAccountInfo> createState() => _ScreenAccountInfoState();
}

class _ScreenAccountInfoState extends State<ScreenAccountInfo> {
  UserModelClass? user;
  final _formKey = GlobalKey<FormState>();

  TextEditingController usercontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  @override
  void initState() {
    DatabaseHelper.instance.getLoggeduser().then((logeduser) {
      user = logeduser;
      usercontroller.text = logeduser.username;
      emailcontroller.text = logeduser.email;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appbarsize = AppBar().preferredSize.height;
    final devicehieght = MediaQuery.sizeOf(context).height - appbarsize;

    return PopScope(
      canPop: false,
      onPopInvoked: (isPoped) async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => ScreenMain(
                    loggedUser: user!,
                    pageIndex: 2,
                  )),
          (route) => false,
        );
      },
      child: Scaffold(
        appBar: appBar(context),
        body: SizedBox(
          height: devicehieght,
          child: Stack(
            children: [
              listTiles(context),
              profilePicture(context),
            ],
          ),
        ),
      ),
    );
  }

  Positioned profilePicture(BuildContext context) {
    return Positioned(
        child: Padding(
      padding: const EdgeInsets.only(top: 45),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 95,
            backgroundColor: Theme.of(context).primaryColor,
            child: Stack(
              children: [
                FutureBuilder(
                  future: DatabaseHelper.instance.getLogedProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final profile = snapshot.data;

                    return CircleAvatar(
                      backgroundImage: FileImage(File(profile!['imagepath'])),
                      radius: 80,
                    );
                  },
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Material(
                      elevation: 1,
                      shape: const CircleBorder(),
                      child: InkWell(
                        child: CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.edit_outlined,
                              color: Colors.grey[700],
                            )),
                        onTap: () => openBottomSheet(),
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Column listTiles(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 160,
          color: Theme.of(context).primaryColor,
          width: double.maxFinite,
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Theme.of(context).colorScheme.background,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 100),
            FutureBuilder(
              future: DatabaseHelper.instance.getLogedProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final user = snapshot.data;
                return CustomListTile(
                    leadingIcon: Icons.person_outline,
                    title: user?['username'],
                    ontap: () {});
              },
            ),
            FutureBuilder(
              future: DatabaseHelper.instance.getLogedProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                final user = snapshot.data;
                return CustomListTile(
                    leadingIcon: Icons.email_outlined,
                    title: user?['email'],
                    ontap: () {});
              },
            ),
            CustomListTile(
                leadingIcon: Icons.lock_outline_rounded,
                title: 'Change Password',
                ontap: changePasswordBottomSheet),
            FutureBuilder(
                future:
                    DatabaseHelper.instance.getUserTrips(widget.loggeduser.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.data == null || !snapshot.hasData) {
                    return Text('Error ${snapshot.error}');
                  }
                  return CustomListTile(
                    leadingIcon: Icons.map,
                    title: 'total Trips',
                    ontap: () {},
                    trail: snapshot.data!.length.toString(),
                  );
                }),
            const SizedBox(height: 120),
            Container(
                padding: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(
                  'svg_logo/triplora-logo.svg',
                  height: 40,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary.withOpacity(.4),
                      BlendMode.srcIn),
                ))
          ]),
        ))
      ],
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 0,
      title: const Text('Account info'),
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => ScreenMain(
                        loggedUser: user!,
                        pageIndex: 2,
                      )),
              (route) => false,
            );
          }),
      actions: [
        IconButton(
          onPressed: showEditBottomSheet,
          icon: const Icon(Icons.mode_edit, color: Colors.white),
        ),
      ],
    );
  }

// username email edit bottom sheet//
  showEditBottomSheet() {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      context: context,
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      height: 5,
                      width: 40,
                      color: Colors.grey,
                    )),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 30),
                CustomTextField(
                    prefix: true,
                    icon: Icons.person_outline,
                    controller: usercontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      } else if (!DatabaseHelper.instance
                          .isUsernameAvailable(value.trim())) {
                        return 'This username is taken';
                      }
                      return null;
                    },
                    label: ''),
                const SizedBox(height: 20),
                CustomTextField(
                    prefix: true,
                    icon: Icons.email_outlined,
                    controller: emailcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!isEmailValid(value)) {
                        return 'invalid email format';
                      }
                      return null;
                    },
                    label: ''),
                const Expanded(child: SizedBox()),
                Container(
                  height: 40,
                  width: double.maxFinite,
                  margin: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary)),
                    onPressed: () {
                      updateuserdata(
                          username: usercontroller.text.trim(),
                          email: emailcontroller.text.trim());
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//  change password bottom sheet //
  changePasswordBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SizedBox(
          height: 450,
          child: Form(
            key: _formKey,
            child: Column(children: [
              const SizedBox(height: 10),
              ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 5,
                    width: 40,
                    color: Colors.grey,
                  )),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'Change Password',
                  style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 30),
              CustomPasswordField(
                label: 'Old Password',
                passcontroller: oldPassController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your previous password';
                  } else if (value != user!.password) {
                    return 'incorrect password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomPasswordField(
                  passcontroller: newPassController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password required';
                    } else if (value.length < 8) {
                      return 'password require 8  charecters';
                    } else if (!value.contains(RegExp(r'[a-z]'))) {
                      return 'Password must contain a letter';
                    } else if (!value.contains(RegExp(r'[0-9]'))) {
                      return 'Password must contain a digit';
                    }
                    return null;
                  },
                  label: 'New Password'),
              const SizedBox(height: 12),
              CustomPasswordField(
                  passcontroller: confirmPassController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return ' confirm  password';
                    } else if (newPassController.text.trim() !=
                        confirmPassController.text.trim()) {
                      return 'Password doesn\'t match';
                    }
                    return null;
                  },
                  label: 'Confirm Password'),
              const Expanded(child: SizedBox()),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                width: double.maxFinite,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                  ),
                  onPressed: passwordUpdation,
                  child: Text('Save',
                      style: TextStyle(
                          color: Theme.of(context).scaffoldBackgroundColor)),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  // Open Custom image choise  Bottom Sheet //
  openBottomSheet() {
    showImageBottomSheet(
      context: context,
      camara: () async => getImage(isCamara: true),
      galary: () async => getImage(isCamara: false),
    );
  }

  // Custom Image picker Function and updating to database //
  getImage({required bool isCamara}) {
    addImage(camera: isCamara, context: context).then((newImage) {
      if (newImage != null) {
        DatabaseHelper.instance
            .updateUserInfo('imagepath', newImage.path, user!.id!);
        setState(() {});
        Navigator.of(context).pop();
      }
    });
  }

  // username and email database updation //
  updateuserdata({String? username, String? email}) async {
    await DatabaseHelper.instance.usernameAvailable(username!);
    if (_formKey.currentState!.validate()) {
      if (email == null) return;
      DatabaseHelper.instance
          .updateUserInfo('username', username, widget.loggeduser.id!);
      DatabaseHelper.instance
          .updateUserInfo('email', email, widget.loggeduser.id!);
      setState(() {});
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  ///////// Change Password Validation /////////////

  passwordUpdation() {
    if (_formKey.currentState!.validate()) {
      DatabaseHelper.instance
          .updateUserInfo('password', newPassController.text.trim(), user!.id!);
      newPassController.text = '';
      confirmPassController.text = '';
      oldPassController.text = '';
      user?.password = newPassController.text;
      Navigator.of(context).pop();

      customToast(bgcolor: Colors.green, msg: 'Password updated successfully');
    }
  }

// Email validation //
  bool validateEmail(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }
}
