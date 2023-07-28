// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';

import '../../Database/database_helper.dart';
import '../../Database/database_models.dart';
import '../../style.dart';

class ScreenDetails extends StatelessWidget {
  ScreenDetails({super.key, required this.trip});
  Trips trip;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10),
      physics: const BouncingScrollPhysics(),
      children: [
        // Starting date and ending date
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Starting Date',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(trip.startingDate,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Ending Date',
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(trip.endingDate,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        // Budget and expenses
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20, top: 20),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ]),
                height: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Budget',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '₹ ${trip.budget}',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          overflow: TextOverflow.ellipsis),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            //////////// Expenses ////////////
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20, top: 20),
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Expenses',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ValueListenableBuilder(
                      valueListenable: totalExpenses,
                      builder:
                          (BuildContext context, int value, Widget? child) {
                        return Text(
                          '₹ $value',
                          style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Balance',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: ValueListenableBuilder(
                            valueListenable: balanceNotifire,
                            builder: (context, value, child) {
                              return Text(
                                '₹ $value',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: value <= 0
                                        ? Colors.red.shade400
                                        : Colors.white,
                                    fontWeight: FontWeight.bold,
                                    overflow: TextOverflow.ellipsis),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        Text(
          'Travel purpose',
          style: subTextStyle(color: secondaryColor),
        ),
        const SizedBox(height: 10),
        // trip purpose
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).colorScheme.onPrimary),
          height: 39,
          child: Text(
            trip.purpose,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(height: 20),
        /////////////// Companion Accordion  /////////////////////
        Text(
          'Companions',
          style: subTextStyle(color: secondaryColor),
        ),
        const SizedBox(height: 5),
        FutureBuilder(
          future: DatabaseHelper.instance.getAllCompanions(trip.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            final compList = snapshot.data;

            return compList!.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(
                      child: Text('You have no Companions'),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1 / 1.3, crossAxisCount: 4),
                    itemCount: compList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            // Theme.of(context).colorScheme.onSecondary,
                            radius: 30,
                            child: Text(
                              compList[index].companion[0],
                              style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      Theme.of(context).colorScheme.background),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Text(
                              compList[index].companion,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          )
                        ],
                      );
                    },
                  );
          },
        )
      ],
    );
  }
}
