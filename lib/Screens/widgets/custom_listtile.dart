// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../style.dart';

class CustomListTile extends StatelessWidget {
  CustomListTile(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.ontap,
      this.trail,
      this.trailing = false});

  IconData leadingIcon;
  bool trailing;
  String? trail;
  String title;
  VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: ontap,
          leading: Icon(
            leadingIcon,
            size: 26,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          title: Text(
            title,
            style:  TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          trailing:trail==null? trailing == true
              ?  Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color:Theme.of(context).colorScheme.surface,
                )
              :null:Text(trail!),
        ),
        const Divider(
          thickness: 1,
          color: Color.fromARGB(137, 236, 236, 236),
          height: 10,
        )
      ],
    );
  }
}

Container expenseTile({required IconData icon,required String label,required int amount,required Color color}) {
    return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ]),
                child: ListTile(
                  leading:  CircleAvatar(
                    backgroundColor: color,
                    child: Icon(
                      icon,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    label,
                    style: subTextStyle(color: mainColor, size: 20),
                  ),
                  trailing: Text('\$ $amount',style: subTextStyle(color: secondaryColor,size: 16),),
                ),
              );
  }