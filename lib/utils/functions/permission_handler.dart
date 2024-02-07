import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> isPermissionGranted(context) async {
    final camara = await Permission.camera.request();
    final storage = await Permission.storage.request();
    final contacts = await Permission.contacts.request();

    if (camara.isDenied || storage.isDenied || contacts.isDenied) {
      return false;
    }

    return true;
  }
}
