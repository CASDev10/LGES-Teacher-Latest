import 'dart:convert';
import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/di/service_locator.dart';
import '../module/auth/repo/auth_repository.dart';

AuthRepository _authRepository = sl<AuthRepository>();

returnSchoolId() {
  return _authRepository.user.schoolId;
}

Future<void> checkCameraPermission() async {
  var status = await Permission.camera.status;
  if (!status.isGranted) {
    await Permission.camera.request();
  }
}

Future<void> saveBase64ToFile2({
  required String base64String,
  required String fileName,
}) async {
  try {
    // Check and request permission to access storage (Android)
    var status = await Permission.manageExternalStorage.request();
    // var status = await Permission.storage.request();

    if (!status.isGranted) {
      print('Storage permission is required to save files.');

      return;
    }

    // Decode the Base64 string to bytes
    List<int> bytes = base64Decode(base64String);
    // Get the external storage directory (camera folder on Android)
    var dir = await getExternalStorageDirectories();

    print("My Directory is --> $dir");
    Directory? externalDir = await getDownloadsDirectory();
    // Directory? dir = await
    if (externalDir == null) {
      print('External storage directory is not available.');
      return;
    }
    String modifyPathToDownload(String originalPath) {
      // Check if the path starts with "/storage/emulated/0/"
      if (originalPath.startsWith('/storage/emulated/0/')) {
        // Find the position of "/0/" and keep everything before that
        int index = originalPath.indexOf('/0/') + 3; // Add 3 to include "/0/"
        String newPath = '${originalPath.substring(0, index)}DCIM/Camera';

        return newPath;
      } else {
        // If the path doesn't match, return the original path or handle it as needed
        print('Invalid path: $originalPath');
        return originalPath;
      }
    }

    // Define the path to the camera folder, adjusting for platform if necessary
    String cameraDirPath = modifyPathToDownload(externalDir.path);

    print("My Directory is --> $cameraDirPath");

    // Ensure the camera directory exists
    Directory cameraDir = Directory(cameraDirPath);
    if (!await cameraDir.exists()) {
      await cameraDir.create(recursive: true);
    }

    // Set the file path to save the image
    String filePath = '$cameraDirPath/$fileName';

    // Create the file and write bytes to it
    File file = File(filePath);
    await file.writeAsBytes(bytes);

    print('File saved at: $filePath');
    openPdfFile(filePath);
  } catch (e) {
    print('Error saving Base64 to file: $e');
  }
}

enum ResultType { done, fileNotFound, noAppToOpen, permissionDenied, error }

Future<void> openUrlInBrowser(String url) async {
  final Uri uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<void> openPdfFile(String filePath) async {
  // Check for storage permission before proceeding
  PermissionStatus permissionStatus = await Permission.storage.request();

  // If permission is not granted, show an alert or handle it accordingly
  if (permissionStatus.isGranted) {
    // Permission is granted, now attempt to open the file
    final result = await OpenFile.open(filePath);

    // Optionally handle the result, such as showing a message if the file can't be opened
    if (result.type == ResultType.error) {
      print('Error opening file: ${result.message}');
    } else {
      print('File opened successfully');
    }
  } else {
    // If permission is denied, show a message or prompt user to allow permission
    print(
      'Storage permission denied. Please grant permission to access the file.',
    );
  }
}
