import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUtils {
  static Future<MultipartFile?> compressImage(String imagePath) async {
    try {
      MultipartFile? image;
      // Compress the image
      XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
        imagePath,
        imagePath.endsWith('.png')
            ? imagePath.replaceAll('.png', '_compressed.jpg')
            : imagePath.replaceAll('.jpg', '_compressed.jpg'),
        minWidth: 1024,
        minHeight: 1024,
        quality: 85,
      );

      if (compressedImage != null) {
        // Get the file size in bytes
        int fileSizeInBytes = File(compressedImage.path).lengthSync();

        // Convert bytes to megabytes (MB)
        double fileSizeInMB = fileSizeInBytes / (1024 * 1024);
        print('size in mb :: $fileSizeInMB');

        // Check if the compressed image is less than 2MB
        if (fileSizeInMB < 2) {
          print(compressedImage.path);
          image = await MultipartFile.fromFile(
            compressedImage.path,
            filename: compressedImage.name,
          );
          return image;
        } else {
          return null;
        }
      }
    } catch (error) {
      print(error);
      return null;
    }
    return null;
  }
}
