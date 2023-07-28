import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wanderlust_new/Database/database_models.dart';

import '../../Database/database_helper.dart';
import '../add_trip_screen.dart';
import '../trip_details_screen.dart';

class SubScreenAllTrips extends StatefulWidget {
  const SubScreenAllTrips({super.key, required this.loggeduser});
  final UserModelClass loggeduser;

  @override
  State<SubScreenAllTrips> createState() => _SubScreenAllTripsState();
}

class _SubScreenAllTripsState extends State<SubScreenAllTrips> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DatabaseHelper.instance.getUserTrips(widget.loggeduser.id!),
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
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset('assets/hero animation.json'),
              ),
              const SizedBox(height: 30),
              Text(
                'No Trips ..?  Plan a new journey',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20),
              ),
              const SizedBox(height: 70)
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
                return InkWell(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    child: Column(
                      children: [
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomLeft: Radius.circular(5))),
                                height: 40,
                                width: 45,
                                child: Icon(
                                  icons[trip.transport],
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
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
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    trip.startingDate,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    child: CircleAvatar(
                                        radius: 13,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        child: Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                );
              },
            ),
            const SizedBox(height: 270)
          ],
        );
      },
    );
  }
}
