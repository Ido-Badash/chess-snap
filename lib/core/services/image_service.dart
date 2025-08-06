import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chess_snap/core/api/chess_snap_api.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImageFromGallery() async {
    try {
      // request appropriate permission based on Android version
      final hasPermission = await _requestGalleryPermission();
      if (!hasPermission) {
        throw Exception('Gallery permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      return image?.path;
    } catch (e) {
      throw Exception('Failed to pick image from gallery: $e');
    }
  }

  static Future<String?> takePhoto() async {
    try {
      // request camera permission
      final cameraStatus = await Permission.camera.request();
      if (cameraStatus.isDenied || cameraStatus.isPermanentlyDenied) {
        throw Exception('Camera permission denied');
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );
      return image?.path;
    } catch (e) {
      throw Exception('Failed to take picture: $e');
    }
  }

  // helper method to request appropriate gallery permission
  static Future<bool> _requestGalleryPermission() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      debugPrint('Android SDK: ${androidInfo.version.sdkInt}'); // debugPrint

      // Android 13 (API 33) and above
      if (androidInfo.version.sdkInt >= 33) {
        final status = await Permission.photos.request();
        debugPrint('Photos permission status: $status'); // debugPrint
        // Accept both granted and limited access
        return status.isGranted || status.isLimited;
      }
      // Android 10-12 (API 29-32)
      else if (androidInfo.version.sdkInt >= 29) {
        debugPrint('Using scoped storage (Android 10-12)'); // debugPrint
        return true; // image_picker handles this automatically
      }
      // Android 9 and below
      else {
        final status = await Permission.storage.request();
        debugPrint('Storage permission status: $status'); // debugPrint
        return status.isGranted;
      }
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      debugPrint('iOS photos permission status: $status'); // debugPrint
      // Accept both granted and limited access for iOS too
      return status.isGranted || status.isLimited;
    }

    return true; // for other platforms
  }

  // method to check current permission status
  static Future<void> checkPermissionStatus() async {
    debugPrint('=== Permission Status Check ===');

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      debugPrint('Android SDK: ${androidInfo.version.sdkInt}');

      if (androidInfo.version.sdkInt >= 33) {
        final photosStatus = await Permission.photos.status;
        debugPrint('Photos permission: $photosStatus');
      } else {
        final storageStatus = await Permission.storage.status;
        debugPrint('Storage permission: $storageStatus');
      }
    } else if (Platform.isIOS) {
      final photosStatus = await Permission.photos.status;
      debugPrint('iOS Photos permission: $photosStatus');
    }

    final cameraStatus = await Permission.camera.status;
    debugPrint('Camera permission: $cameraStatus');
    debugPrint('==============================');
  }

  static Future<String> processImageToFen(String imagePath) async {
    // check if server is reachable first
    final bool isServerReachable = await ChessSnapApi.isServerReachable("get_fen");
    if (!isServerReachable) {
      throw ChessSnapApiException(
        "Cannot connect to the chess recognition server. Make sure the Python server is running.",
      );
    }

    // convert image to FEN using the API
    final File imageFile = File(imagePath);
    return await ChessSnapApi.getFenFromFile(imageFile);
  }
}
