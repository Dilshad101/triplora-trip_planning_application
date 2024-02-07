
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wanderlust_new/models/trip_model.dart';

import '../models/user_model.dart';
import '../screens/add_trip_screen.dart';
import '../screens/subscreen_trip_details/trip_details_screen.dart';

class TripTile extends StatelessWidget {
  const TripTile({
    super.key,
    required this.user,
    required this.trip,
  });

  final Trips trip;
  final UserModelClass user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        child: Column(
          children: [
            // trip tile Image
            Expanded(
                child: Container(
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
            )),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(5)),
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 80,
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          trip.startingDate,
                          style: TextStyle(
                            fontSize: 13,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: CircleAvatar(
                            radius: 13,
                            backgroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: Theme.of(context).colorScheme.primary,
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
                  loggedUser: user,
                  trip: trip,
                )));
      },
    );
  }
}
