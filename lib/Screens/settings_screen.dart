
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:wanderlust_new/database/database_helper.dart';
import 'package:wanderlust_new/screens/account_info_screen.dart';
import 'package:wanderlust_new/screens/app_info_screen.dart';
import 'package:wanderlust_new/screens/privacy_policy_screen.dart';
import 'package:wanderlust_new/utils/themes/theme_provider.dart';
import 'package:wanderlust_new/utils/messages/flush_bar.dart';
import 'package:wanderlust_new/utils/messages/popup.dart';

import '../models/user_model.dart';
import '../widgets/custom_listtile.dart';
import 'signin_screen.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key, required this.loggeduser});
 final UserModelClass loggeduser;

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              profile(context),
              settingsTile(context),
            ],
          ),
        ));
  }

  Expanded settingsTile(BuildContext context) {
    return Expanded(
        child: Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        CustomListTile(
            leadingIcon: Icons.person_outline_rounded,
            title: 'Account info',
            ontap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ScreenAccountInfo(
                    loggeduser: widget.loggeduser,
                  ),
                ),
              );
            },
            trailing: true),
        CustomListTile(
          leadingIcon: Icons.lock_outline_rounded,
          ontap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => const ScreenPrivacyPolicy()),
          ),
          title: 'privacy policy',
          trailing: true,
        ),
        CustomListTile(
          leadingIcon: Icons.info_outline_rounded,
          title: 'App info',
          ontap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ScreenAppInfo()));
          },
          trailing: true,
        ),
        ListTile(
          leading: Icon(
            Icons.nights_stay_outlined,
            size: 26,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            'Dark Mode',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          trailing: Switch(
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            inactiveThumbColor: Theme.of(context).colorScheme.primary,
            trackColor: MaterialStateProperty.all(Colors.white),
            trackOutlineColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.primary),
            onChanged: (value) {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ),
        const Divider(
          thickness: 1,
          color: Color.fromARGB(137, 236, 236, 236),
          height: 10,
        ),
        CustomListTile(
            leadingIcon: Icons.delete_outline_rounded,
            ontap: deleteAllTrips,
            title: 'Delete all Trips'),
        CustomListTile(
          leadingIcon: Icons.logout_rounded,
          title: 'Sign out',
          ontap: signOut,
        ),
        const SizedBox(height: 45),
        SvgPicture.asset(
          'svg_logo/triplora-logo.svg',
          height: 40,
          colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.primary.withOpacity(.4),
              BlendMode.srcIn),
        )
      ],
    ));
  }

  Container profile(BuildContext context) {
    return Container(
      height: 230,
      color: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
            future: DatabaseHelper.instance.getLogedProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final user = snapshot.data;

              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, top: 50),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: FileImage(File(user?['imagepath'])),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: SizedBox(
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?['username'],
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                          Text(user?['email'],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  signOut() {
    popUpAlert(
      context: context,
      title: 'Sign out your account',
      optionOne: () {
        DatabaseHelper.instance.logoutUser();
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ScreenLogin()));
      },
      optionTwo: () => Navigator.of(context).pop(),
    );
  }

  deleteAllTrips() {
    popUpAlert(
      context: context,
      title: 'Delete All your Trip',
      optionOne: () {
        DatabaseHelper.instance.deleteAllTrips(
          widget.loggeduser.id!,
        );
        Navigator.of(context).pop();
        customToast(bgcolor: Colors.green, msg: 'All Trips were deleted');
      },
      optionTwo: () => Navigator.of(context).pop(),
    );
  }
}
