import 'package:flutter/material.dart';

import '../../style.dart';

Container customGrid(
    {required String text,
    required int amount,
    required IconData icon,
    required Color amountColor,
    required Color bgcolor,
    required Color iconColor}) {
  return Container(
    height: 80,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: Colors.grey),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text("₹ $amount",
                style: subTextStyle(color: amountColor, size: 16))),
        const SizedBox(
          height: 5,
        ),
        const Divider(thickness: 1, height: 18),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            children: [
              Text(text,
                  style: subTextStyle(size: 18, color: Colors.grey.shade700)),
              Expanded(child: Container()),
              CircleAvatar(
                  backgroundColor: bgcolor,
                  radius: 18,
                  child: Icon(
                    icon,
                    size: 19,
                    color: iconColor,
                  )),
              const SizedBox(width: 15)
            ],
          ),
        )
      ],
    ),
  );
}
