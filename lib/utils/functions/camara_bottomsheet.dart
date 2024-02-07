import 'package:flutter/material.dart';

showImageBottomSheet(
    {required BuildContext context,
    required Function() camara,
    required Function() galary}) {
  return showModalBottomSheet(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    context: context,
    builder: (ctx) {
      return SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text('Select From',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              child: ListTile(
                onTap: camara,
                leading: Icon(
                  Icons.camera_alt_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                title: const Text('Camera'),
              ),
            ),
            const SizedBox(height: 5),
            Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: ListTile(
                  leading: Icon(Icons.image_outlined,
                      color: Theme.of(context).colorScheme.primary),
                  title: const Text('Gallery'),
                  onTap: galary),
            )
          ],
        ),
      );
    },
  );
}
