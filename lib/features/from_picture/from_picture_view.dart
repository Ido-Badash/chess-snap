import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chess_snap/core/api/chess_snap_api.dart';

class FromPictureView extends StatefulWidget {
  final void Function()? onExit;

  const FromPictureView({super.key, this.onExit});

  @override
  State<FromPictureView> createState() => _FromPictureViewState();
}

class _FromPictureViewState extends State<FromPictureView> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  String? _errorMessage;
  String? _selectedImagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Back button
          Positioned(
            top: 40,
            left: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onExit ?? () => Navigator.of(context).pop(),
            ),
          ),

          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show selected image preview
                  if (_selectedImagePath != null)
                    Container(
                      height: 200,
                      width: 200,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Image.file(
                        File(_selectedImagePath!),
                        fit: BoxFit.cover,
                      ),
                    ),

                  // Error message
                  if (_errorMessage != null)
                    Container(
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
                    ),

                  // Loading indicator
                  if (_isProcessing)
                    const Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text("Analyzing chess position..."),
                      ],
                    )
                  else
                    Column(
                      children: [
                        // Gallery button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: onGalleryPressed,
                            icon: const Icon(
                              Icons.photo_library,
                              size: 28,
                              color: Colors.indigoAccent,
                            ),
                            label: const Text(
                              "From Gallery",
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Camera button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: onCameraPressed,
                            icon: const Icon(
                              Icons.camera_alt,
                              size: 28,
                              color: Colors.indigoAccent,
                            ),
                            label: const Text(
                              "Take a Picture",
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),

                        // Process button (only show if image is selected)
                        if (_selectedImagePath != null) ...[
                          const SizedBox(height: 20),
                          SizedBox(
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
                          ),
                        ],
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onGalleryPressed() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress image to reduce size
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image from gallery: $e';
      });
    }
  }

  Future<void> onCameraPressed() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Compress image to reduce size
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to take picture: $e';
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
      // Check if server is reachable first
      final bool isServerReachable = await ChessSnapApi.isServerReachable();
      if (!isServerReachable) {
        throw ChessSnapApiException(
          'Cannot connect to the chess recognition server. Please make sure the Python server is running on localhost:5000',
        );
      }

      // Convert image to FEN using the API
      final File imageFile = File(_selectedImagePath!);
      final String fen = await ChessSnapApi.getFenFromFile(imageFile);

      // Navigate to game with the detected FEN
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Text("Link to game: $fen")),
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
}
