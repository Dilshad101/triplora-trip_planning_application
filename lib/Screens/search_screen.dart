import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:wanderlust_new/Database/database_helper.dart';
import 'package:wanderlust_new/Database/database_models.dart';
import 'package:wanderlust_new/Screens/add_trip_screen.dart';

import 'trip_details_screen.dart';

class ScreenSearch extends StatefulWidget {
  const ScreenSearch({super.key, required this.loggeduser});
  final UserModelClass loggeduser;

  @override
  State<ScreenSearch> createState() => _ScreenSearchState();
}

class _ScreenSearchState extends State<ScreenSearch> {
  final searchController = TextEditingController();
  List<Trips> filteredList = [];
  List<Trips> userTrips = [];
  bool notFound = false;

  @override
  void initState() {
    super.initState();
    DatabaseHelper.instance.getUserTrips(widget.loggeduser.id!).then((value) {
      userTrips = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          const SizedBox(height: 25),
          Container(
            height: 60,
            decoration: BoxDecoration(
                //  color: Colors.grey.shade200,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                borderRadius: BorderRadius.circular(30)),
            width: double.infinity,
            child: Row(
              children: [
                const SizedBox(width: 5),
                IconButton(
                  icon: const Icon(LineAwesome.arrow_left_solid, size: 26),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: TextField(
                  decoration: const InputDecoration(
                      hintText: 'Search', border: InputBorder.none),
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      filteredList = userTrips
                          .where((trip) => trip.destination
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                      if (filteredList.isEmpty) {
                        notFound = true;
                      }
                      if (value.isEmpty) {
                        filteredList.clear();
                        notFound = false;
                      }
                    });
                  },
                )),
                 IconButton(icon:const Icon(IonIcons.close),onPressed: (){

                  setState(() {
                    searchController.text='';
                    filteredList.clear();
                    notFound=false;
                  });
                 }),
                const SizedBox(width: 5),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            child: filteredList.isEmpty
                ? Center(
                    child: Container(
                      height: 300,
                      width: double.maxFinite,
                      alignment: Alignment.center,
                      child: notFound
                          ? const Text('No result found')
                          :  Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  BoxIcons.bxs_binoculars,
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(.3),
                                  size: 60,
                                ),
                                Text(
                                  'Search',
                                  style: TextStyle(fontSize: 20,
                                  letterSpacing: 4,
                                  color: Theme.of(context).colorScheme.onBackground.withOpacity(.5)),
                                ),
                              ],
                            ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final trip = filteredList[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: trip.assetImgIdx == null
                                ? FileImage(File(trip.fileImage!))
                                : AssetImage(imageList[trip.assetImgIdx!])
                                    as ImageProvider,
                          ),
                          title: Text(
                            trip.destination,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            trip.startingDate,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ScreenTripDetails(
                                      trip: trip,
                                      loggedUser: widget.loggeduser),
                                ),
                              );
                            },
                            icon: const Icon(Icons.arrow_forward_ios_rounded),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                  ),
          ),
        ],
      )),
    );
  }
}
