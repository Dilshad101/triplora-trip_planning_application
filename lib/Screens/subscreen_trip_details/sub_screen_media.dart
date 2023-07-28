// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wanderlust_new/Database/database_helper.dart';
import 'package:wanderlust_new/Screens/subscreen_trip_details/sub_screen_image_details.dart';

import '../../Database/database_models.dart';
import '../../Functionality/camara_bottomsheet.dart';
import '../../Functionality/image_picker_function.dart';
import 'note_editing_screen.dart';

class SubScreenMedia extends StatefulWidget {
  SubScreenMedia({super.key, required this.trip});
  Trips trip;

  @override
  State<SubScreenMedia> createState() => _SubScreenMediaState();
}

class _SubScreenMediaState extends State<SubScreenMedia> {
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getTripnote().then((storedNote) {
      noteController.text = storedNote ?? '';
    });
  }

  Future<String?> getTripnote() async {
    final temptrip = await DatabaseHelper.instance.getATrip(widget.trip.id!);

    return temptrip.notes;
  }

  File? images;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Images',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onTertiary)),
              const Expanded(child: SizedBox()),
              InkWell(
                  onTap: () {
                    showImageBottomSheet(
                      context: context,
                      camara: () {
                        addTripImage(camara: true);
                      },
                      galary: () {
                        addTripImage(camara: false);
                      },
                    );
                  },
                  child: Icon(Icons.add_photo_alternate,
                      size: 25,
                      color: Theme.of(context).colorScheme.onTertiary))
            ],
          ),
          const SizedBox(height: 10),
          Container(
              constraints: const BoxConstraints(minHeight: 100),
              child: FutureBuilder(
                future: DatabaseHelper.instance.getallImages(widget.trip.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text(
                      'No images available. add a new image',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ));
                  }
                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      final image = snapshot.data![index];
                      return GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: FileImage(File(image['images'])),
                                  fit: BoxFit.cover),
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ScreenImageView(
                                    imagepath: image['images'],
                                    id: image['id'],
                                  )));
                        },
                      );
                    },
                  );
                },
              )),
          const SizedBox(height: 30),
          Row(
            children: [
              Text(
                'Notes',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onTertiary),
              ),
              const Expanded(child: SizedBox()),
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NoteEditingPad(
                              trip: widget.trip,
                              controller: noteController,
                            )));
                  },
                  child: Icon(Icons.edit_note_outlined,
                      size: 28,
                      color: Theme.of(context).colorScheme.onTertiary)),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(minHeight: 180),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                borderRadius: BorderRadius.circular(5)),
            child: TextFormField(
              style:const TextStyle(color: Colors.grey),
              readOnly: true,
              maxLines: 10,
              textAlign: TextAlign.justify,
              controller: noteController,
              decoration: const InputDecoration(
                
                  hintText: 'note is empty', border: InputBorder.none),
              
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  addTripImage({required bool camara}) async {
    if (camara) {
      final image = await addImage(camera: camara, context: context);

      if (image == null) return;
      await DatabaseHelper.instance
          .addTripImages(imagePath: image.path, tripId: widget.trip.id!);
    } else {
      final selectedImages = await addMultiImages();
      for (XFile image in selectedImages) {
        await DatabaseHelper.instance
            .addTripImages(imagePath: image.path, tripId: widget.trip.id!);
      }
    }
    setState(() {});
    Navigator.of(context).pop();
  }
}
