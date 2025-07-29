import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chess_snap/core/api/chess_snap_api.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  static Future<String?> pickImageFromGallery() async {
    try {
      // Request storage permission for gallery access
      final status = await Permission.storage.request();
      if (status.isDenied) {
        throw Exception('Storage permission denied');
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
      // Request camera permission
      final cameraStatus = await Permission.camera.request();
      if (cameraStatus.isDenied) {
        throw Exception('Camera permission denied');
      }

      // Request storage permission for saving photos
      final storageStatus = await Permission.storage.request();
      if (storageStatus.isDenied) {
        throw Exception('Storage permission denied');
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

  static Future<String> processImageToFen(String imagePath) async {
    // Check if server is reachable first
    final bool isServerReachable = await ChessSnapApi.isServerReachable();
    if (!isServerReachable) {
      throw ChessSnapApiException(
        "Cannot connect to the chess recognition server. Make sure the Python server is running.",
      );
    }

    // Convert image to FEN using the API
    final File imageFile = File(imagePath);
    return await ChessSnapApi.getFenFromFile(imageFile);
  }
}
