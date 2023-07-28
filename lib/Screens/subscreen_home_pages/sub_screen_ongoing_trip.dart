import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wanderlust_new/Database/database_helper.dart';
import 'package:wanderlust_new/Database/database_models.dart';
import 'package:wanderlust_new/Screens/add_trip_screen.dart';

import '../trip_details_screen.dart';

class SubScreenOngoinTrip extends StatefulWidget {
  const SubScreenOngoinTrip({super.key, required this.loggeduser});
  final UserModelClass loggeduser;
  @override
  State<SubScreenOngoinTrip> createState() => _SubScreenOngoinTripState();
}

class _SubScreenOngoinTripState extends State<SubScreenOngoinTrip> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.getCurrentTrip(widget.loggeduser.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.data == null || snapshot.hasError) {
          return Center(child: Text('Somthing went wrong ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
              height: 300,
              width: double.maxFinite,
              alignment: Alignment.center,
              child: Text(
                'You have no ongoing Trips..!',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20),
              ));
        }
        final trip = snapshot.data!.first;
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 40),
            InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 220,
                      margin: const EdgeInsets.all(12),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        image: DecorationImage(
                          image: trip.assetImgIdx == null
                              ? FileImage(File(trip.fileImage!))
                              : AssetImage(imageList[trip.assetImgIdx!])
                                  as ImageProvider<Object>,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                            height: 40,
                            width: 45,
                            child: Icon(
                              icons[trip.transport],
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(5)),
                      width: double.maxFinite,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.destination,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                trip.startingDate,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              const Expanded(child: SizedBox()),
                              CircleAvatar(
                                radius: 14,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                child: CircleAvatar(
                                    radius: 13,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.onPrimary,
                                    child: Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 14,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ScreenTripDetails(
                          loggedUser: widget.loggeduser,
                          trip: trip,
                        )));
              },
            ),
          ],
        );
      },
    );
  }
}
