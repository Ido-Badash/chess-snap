import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chess_snap/core/widgets/button.dart';

class MainContent extends StatelessWidget {
  final String? selectedImagePath;
  final String? errorMessage;
  final bool isProcessing;
  final String? detectedFen;
  final VoidCallback onGalleryPressed;
  final VoidCallback onCameraPressed;
  final VoidCallback onProcessImage;
  final VoidCallback onRemoveImage;

  const MainContent({
    super.key,
    required this.selectedImagePath,
    required this.errorMessage,
    required this.isProcessing,
    required this.detectedFen,
    required this.onGalleryPressed,
    required this.onCameraPressed,
    required this.onProcessImage,
    required this.onRemoveImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          if (selectedImagePath != null) _buildImagePreview(),
          if (errorMessage != null) _buildErrorMessage(),
          if (isProcessing) _buildLoadingIndicator() else _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      width: 300,
      margin: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(File(selectedImagePath!), fit: BoxFit.cover),
            if (!isProcessing && detectedFen == null)
              Positioned(
                top: 12,
                right: 12,
                child: Material(
                  color: Colors.transparent,
                  child: Ink(
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onRemoveImage,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.close, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            children: [
              const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          "Analyzing chess position...",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "This may take a few seconds",
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    if (detectedFen != null) return const SizedBox.shrink();

    return Column(
      children: [
        if (selectedImagePath == null) ...[
          Text(
            "Choose how to capture your chess board",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Take a clear photo showing the entire board at 45° angle.",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            "Make sure the image is taken from the white side.",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
        ],

        _buildGalleryButton(),
        const SizedBox(height: 20),
        _buildCameraButton(),

        if (selectedImagePath != null) ...[
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Image selected! Ready to analyze",
                    style: TextStyle(
                      color: Colors.green.shade100,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildProcessButton(),
        ],
      ],
    );
  }

  Widget _buildGalleryButton() {
    return GradientActionButton(
      gradientColors: const [Color(0xFF667eea), Color(0xFF764ba2)],
      shadowColor: const Color(0xFF667eea),
      leadingIcon: const Icon(
        Icons.photo_library_outlined,
        color: Colors.white,
        size: 24,
      ),
      trailingIcon: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white.withValues(alpha: 0.7),
        size: 16,
      ),
      width: 300,
      height: 60,
      label: "From Gallery",
      onPressed: onGalleryPressed,
    );
  }

  Widget _buildCameraButton() {
    return GradientActionButton(
      gradientColors: const [Color(0xFF2193b0), Color(0xFF6dd5ed)],
      shadowColor: const Color(0xFF2193b0),
      leadingIcon: const Icon(
        Icons.camera_alt_outlined,
        color: Colors.white,
        size: 24,
      ),
      trailingIcon: Icon(
        Icons.arrow_forward_ios,
        color: Colors.white.withValues(alpha: 0.7),
        size: 16,
      ),
      width: 300,
      height: 60,
      label: "Take a Picture",
      onPressed: onCameraPressed,
    );
  }

  Widget _buildProcessButton() {
    return GradientActionButton(
      gradientColors: const [Color(0xFF2ecc71), Color(0xFF16a085)],
      shadowColor: const Color(0xFF2ecc71),
      leadingIcon: const Icon(
        Icons.auto_awesome,
        color: Colors.white,
        size: 24,
      ),
      trailingIcon: const Icon(Icons.psychology, color: Colors.white, size: 16),
      width: 300,
      height: 60,
      label: "Analyze Position",
      onPressed: onProcessImage,
    );
  }
}
