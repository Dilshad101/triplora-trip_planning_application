// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:wanderlust_new/Screens/settings_screen.dart';

import '../Database/database_models.dart';
import 'add_trip_screen.dart';
import 'home_screen.dart';

class ScreenMain extends StatefulWidget {
  ScreenMain({super.key, required this.loggedUser, this.pageIndex});

  UserModelClass loggedUser;
  int? pageIndex;
  @override
  State<ScreenMain> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenMain> {
  int currentpage = 0;

  @override
  void initState() {
    super.initState();
    currentpage = widget.pageIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      ScreenHome(loggeduser: widget.loggedUser),
      MyAddTrip(loggedUser: widget.loggedUser),
      ScreenSettings(loggeduser: widget.loggedUser),
    ];

    return Stack(
      children: [
        Scaffold(
          // backgroundColor: const Color(0xFFF7F7F7),
          body: screens[currentpage],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 20,
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(50),
            ),
            child: GNav(
              activeColor: Theme.of(context).colorScheme.onPrimary,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 200),
              tabBackgroundColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).colorScheme.surface,
              curve: Curves.linear,
              tabs: const [
                GButton(
                  icon: OctIcons.home_16,
                  text: 'Home',
                  gap: 5,
                  iconSize: 25,
                ),
                GButton(
                  icon: Icons.add,
                  text: 'Add Trip',
                  gap: 4,
                  iconSize: 25,
                ),
                GButton(
                  icon: EvaIcons.settings_outline,
                  text: 'Settings',
                  gap: 5,
                  iconSize: 25,
                )
              ],
              selectedIndex: currentpage,
              onTabChange: (value) {
                setState(() {
                  currentpage = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
