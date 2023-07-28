// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wanderlust_new/Database/database_helper.dart';
import 'package:wanderlust_new/Screens/add_trip_screen.dart';
import 'package:wanderlust_new/Screens/parent_screen.dart';
import 'package:wanderlust_new/style.dart';

import '../Database/database_models.dart';
import '../messages/popup.dart';
import 'subscreen_trip_details/sub_screen_details.dart';
import 'subscreen_trip_details/sub_screen_expenses.dart';
import 'subscreen_trip_details/sub_screen_media.dart';

class ScreenTripDetails extends StatefulWidget {
  ScreenTripDetails({super.key, required this.trip, required this.loggedUser});
  Trips trip;
  UserModelClass loggedUser;

  @override
  State<ScreenTripDetails> createState() => _ScreenTripDetailsState();
}

class _ScreenTripDetailsState extends State<ScreenTripDetails>
    with SingleTickerProviderStateMixin {
  String? notes;
  bool isvisible = false;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.getExpense(widget.trip.id!);
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      //appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
              size: 28,
            )),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 0) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MyAddTrip(
                          loggedUser: widget.loggedUser,
                          isEdit: true,
                          trip: widget.trip,
                        )));
              }else if (value == 1) {
                popUpAlert(
                    context: context,
                    title: 'Delete Trip',
                    optionOne: () {
                      DatabaseHelper.instance.deleteTrip(widget.trip);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) =>
                                ScreenMain(loggedUser: widget.loggedUser),
                          ),
                          (route) => false);
                    },
                    optionTwo: () {
                      Navigator.of(context).pop();
                    });
              }
            },
            color: Theme.of(context).colorScheme.background,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    value: 0,
                    child: Text('Edit',
                        style: subTextStyle(
                            color: Colors.grey.shade600,
                            weight: FontWeight.w500))),
            
                PopupMenuItem(
                    value: 1,
                    child: Text('Delete',
                        style: subTextStyle(
                            color: Colors.grey.shade600,
                            weight: FontWeight.w500)))
              ];
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                // CoverImage
                SizedBox(
                  height: 230,
                  width: double.maxFinite,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image(
                        image: widget.trip.assetImgIdx == null
                            ? FileImage(File(widget.trip.fileImage!))
                            : AssetImage(imageList[widget.trip.assetImgIdx!])
                                as ImageProvider<Object>,
                        fit: BoxFit.cover,
                      )),
                ),
                //container for shadow
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                      // color: Colors.transparent,
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Destination and Travel type
                Positioned(
                  bottom: 5,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.trip.destination,
                          style: const TextStyle(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 43,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFF3C654D),
                          ),
                          child: Icon(
                            icons[widget.trip.transport],
                            size: 22,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            // Tab bar
            TabBar(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              tabs: const [
                Text('Details', style: TextStyle(fontSize: 15)),
                Text('Media', style: TextStyle(fontSize: 15)),
                Text('Expenses', style: TextStyle(fontSize: 15)),
              ],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey.shade500,
              indicator: CircleIndicator(
                  color: Theme.of(context).colorScheme.primary, radius: 4),
            ),
            const SizedBox(
              height: 20,
            ),
            // Tab bar view
            Expanded(
              child: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  controller: _tabController,
                  children: [
                    ScreenDetails(trip: widget.trip),
                    SubScreenMedia(trip: widget.trip),
                    SubScreenExpense(trip: widget.trip),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  // deleteConfirmation() {
  //   popupAlert();
  // }

  // Future<dynamic> popupAlert() {
  //   return popUpAlert();
  // }
}
