import 'dart:io';
import 'package:chess_snap/features/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:chess_snap/core/api/chess_snap_api.dart';
import 'package:chess_snap/core/services/image_service.dart';

class FromPictureView extends StatefulWidget {
  final void Function()? onExit;

  const FromPictureView({super.key, this.onExit});

  @override
  State<FromPictureView> createState() => _FromPictureViewState();
}

class _FromPictureViewState extends State<FromPictureView> {
  bool _isProcessing = false;
  String? _errorMessage;
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackButton(context),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: _buildMainContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Positioned(
      top: 40,
      left: 8,
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: widget.onExit ?? () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_selectedImagePath != null) _buildImagePreview(),
        if (_errorMessage != null) _buildErrorMessage(),
        if (_isProcessing) _buildLoadingIndicator() else _buildActionButtons(),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      width: 200,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.file(File(_selectedImagePath!), fit: BoxFit.cover),
    );
  }

  Widget _buildErrorMessage() {
    debugPrint("Errror message: $_errorMessage");
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Column(
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text("Analyzing chess position..."),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildGalleryButton(),
        const SizedBox(height: 20),
        _buildCameraButton(),
        if (_selectedImagePath != null) ...[
          const SizedBox(height: 20),
          _buildProcessButton(),
        ],
      ],
    );
  }

  Widget _buildGalleryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _onGalleryPressed,
        icon: const Icon(
          Icons.photo_library,
          size: 28,
          color: Colors.indigoAccent,
        ),
        label: const Text("From Gallery", style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
      ),
    );
  }

  Widget _buildCameraButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _onCameraPressed,
        icon: const Icon(
          Icons.camera_alt,
          size: 28,
          color: Colors.indigoAccent,
        ),
        label: const Text("Take a Picture", style: TextStyle(fontSize: 16)),
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
      ),
    );
  }

  Widget _buildProcessButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _processImage,
        icon: const Icon(Icons.psychology),
        label: const Text(
          "Analyze Chess Position",
          style: TextStyle(fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Future<void> _onGalleryPressed() async {
    try {
      final String? imagePath = await ImageService.pickImageFromGallery();
      if (imagePath != null) {
        setState(() {
          _selectedImagePath = imagePath;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getPermissionErrorMessage(e.toString());
      });
    }
  }

  Future<void> _onCameraPressed() async {
    try {
      final String? imagePath = await ImageService.takePhoto();
      if (imagePath != null) {
        setState(() {
          _selectedImagePath = imagePath;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getPermissionErrorMessage(e.toString());
      });
    }
  }

  Future<void> _processImage() async {
    if (_selectedImagePath == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final bool isServerReachable = await ChessSnapApi.isServerReachable();
      if (!isServerReachable) {
        debugPrint("Server is not reachable");
        throw ChessSnapApiException(
          "Cannot connect to the chess recognition server.",
        );
      }

      final File imageFile = File(_selectedImagePath!);
      final String fen = await ChessSnapApi.getFenFromFile(imageFile);

      if (mounted) {
        // Navigate to the result screen instead
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(fen: fen)),
        );
      }
    } on ChessSnapApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  String _getPermissionErrorMessage(String error) {
    if (error.contains('Camera permission denied')) {
      return 'Camera permission is required to take photos. Please enable it in app settings.';
    } else if (error.contains('Storage permission denied')) {
      return 'Storage permission is required to access photos. Please enable it in app settings.';
    }
    return error;
  }
}
