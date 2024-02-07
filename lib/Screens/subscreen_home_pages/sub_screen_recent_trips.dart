import 'package:flutter/material.dart';
import 'package:wanderlust_new/database/database_helper.dart';

import '../../models/user_model.dart';
import '../../widgets/trip_tile.dart';

class SubScreenRecentTrips extends StatefulWidget {
  const SubScreenRecentTrips({super.key, required this.loggeduser});
  final UserModelClass loggeduser;
  @override
  State<SubScreenRecentTrips> createState() => _SubScreenRecentTripsState();
}

class _SubScreenRecentTripsState extends State<SubScreenRecentTrips> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.getCompletedTrips(widget.loggeduser.id!),
      builder: (context, snapshot) {
        if (snapshot.hasError || !snapshot.hasData) {
          return Text('Error ${snapshot.error}');
        } else if (!snapshot.hasData ||
            snapshot.data == null ||
            snapshot.data!.isEmpty) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'You have no recent Trips...!',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20),
              ),
            ],
          ));
        }
        final tripList = snapshot.data;

        return ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20),
          children: [
            const SizedBox(height: 40),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.4,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              itemCount: tripList!.length,
              itemBuilder: (context, index) {
                final trip = tripList[index];
                return TripTile(trip: trip, user: widget.loggeduser);
              },
            ),
            const SizedBox(height: 270)
          ],
        );
      },
    );
  }
}
