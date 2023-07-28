import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:wanderlust_new/Database/database_helper.dart';
import 'package:wanderlust_new/Screens/search_screen.dart';
import 'package:wanderlust_new/Screens/subscreen_home_pages/sub_screen_all_trips.dart';
import 'package:wanderlust_new/Screens/subscreen_home_pages/sub_screen_ongoing_trip.dart';
import 'package:wanderlust_new/Screens/subscreen_home_pages/sub_screen_recent_trips.dart';
import 'package:wanderlust_new/Screens/subscreen_home_pages/sub_screen_upcoming_trip.dart';
import 'package:wanderlust_new/style.dart';

import '../Database/database_models.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key, required this.loggeduser});
  final UserModelClass loggeduser;

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        // backgroundColor: const Color.fromARGB(255, 243, 243, 243),
        elevation: 0,
        title: FutureBuilder(
            future: DatabaseHelper.instance.getLogedProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error ${snapshot.error}');
              }
              final user = snapshot.data;
              return Text(
                " Hi , ${user?['username']}",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              );
            }),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: DatabaseHelper.instance.getLogedProfile(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                }
                final user = snapshot.data;
                return CircleAvatar(
                    radius: 20,
                    backgroundImage: FileImage(File(user?['imagepath'])));
              }),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScreenSearch(
                          loggeduser: widget.loggeduser,
                        )));
              },
              icon: Icon(
                IonIcons.search,
                color: Theme.of(context).colorScheme.primary,
              )),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.only(left: 20),
              height: 40,
              alignment: Alignment.centerLeft,
              child: TabBar(
                labelPadding: const EdgeInsets.only(right: 10, left: 15),
                isScrollable: true,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Colors.grey.shade500,
                indicator: CircleIndicator(
                    color: Theme.of(context).colorScheme.primary, radius: 4),
                controller: _tabController,
                tabs: const [
                  Tab(text: 'All Trips'),
                  Tab(text: 'On going'),
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Recent'),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: _tabController,
                  children: [
                    SubScreenAllTrips(loggeduser: widget.loggeduser),
                    SubScreenOngoinTrip(loggeduser: widget.loggeduser),
                    SubScreenUpcomingTrips(loggeduser: widget.loggeduser),
                    SubScreenRecentTrips(loggeduser: widget.loggeduser)
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
