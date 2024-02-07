import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> addImage(
    {required bool camera, required BuildContext context}) async {
  final pickedImage = await ImagePicker().pickImage(
      source: camera == true ? ImageSource.camera : ImageSource.gallery);
  if (pickedImage == null) return null;

  CroppedFile? croppedImage;

  croppedImage = await ImageCropper().cropImage(
      sourcePath: pickedImage.path,
      // aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3
      ],
      maxHeight: 1000,
      maxWidth: 1000,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90);
  if (croppedImage == null) return null;
  final images = File(croppedImage.path);
  return images;
}


 Future<List<XFile>> addMultiImages()async{
  List<XFile> imageList=[];
   imageList=await ImagePicker().pickMultiImage();
  
  return imageList;
}