import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_share/flutter_share.dart';

String getAgoraAppId() {
  return "<YOUR APP ID HERE>"; // Return Your Agora App Id
}

checkNoSignleDigit(int no) {
  int len = no.toString().length;
  if (len == 1) {
    return true;
  }
  return false;
}

String generateRandomString(int len) {
  var r = Random();
  const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
}

void shareToApps(String roomId) async {
  await FlutterShare.share(
    title: 'Video Call Invite',
    text: 'Hey There, Lets Connect via Video call in App using code : $roomId',
  );
}

Future<bool> handlePermissionsForCall(BuildContext context) async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.camera,
    Permission.microphone,
    Permission.storage,
  ].request();

  if (statuses[Permission.storage]?.isPermanentlyDenied ?? false) {
    showCustomDialog(context, "Permission Required", "Storage Permission Required for Video Call", () {
      Navigator.pop(context);
      openAppSettings();
    });
    return false;
  } else if (statuses[Permission.camera]?.isPermanentlyDenied ?? false) {
    showCustomDialog(context, "Permission Required", "Camera Permission Required for Video Call", () {
      Navigator.pop(context);
      openAppSettings();
    });
    return false;
  } else if (statuses[Permission.microphone]?.isPermanentlyDenied ?? false) {
    showCustomDialog(context, "Permission Required", "Microphone Permission Required for Video Call", () {
      Navigator.pop(context);
      openAppSettings();
    });
    return false;
  }

  if (statuses[Permission.storage]?.isDenied ?? true) {
    return false;
  } else if (statuses[Permission.camera]?.isDenied ?? true) {
    return false;
  } else if (statuses[Permission.microphone]?.isDenied ?? true) {
    return false;
  }
  return true;
}

void showCustomDialog(BuildContext context, String title, String message, Function() okPressed) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // return object of type Dialog

      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(
          title,
          style: const TextStyle(fontFamily: 'WorkSansMedium'),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'WorkSansMedium'),
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: okPressed,
            child: const Text("OK", style: TextStyle(fontFamily: 'WorkSansMedium')),
          ),
        ],
      );
    },
  );
}
