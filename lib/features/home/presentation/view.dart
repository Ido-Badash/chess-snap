import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          buildAppDescription(screenWidth, screenHeight),
          const SizedBox(height: 20.0), // Add spacing between sections
          buildCenteredButtons(screenWidth),
        ],
      ),
    );
  }

  // App description builder
  Widget buildAppDescription(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "ChessScan & Play: Transform Your Game!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10.0), // Add spacing between text
          const Text(
            "Capture any chessboard, anywhere, and play instantly!\n"
            "Revolutionize how you practice and enjoy chess!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20.0), // Add spacing before image
          Image.asset(
            "assets/images/home_pieces_bg.png",
            width: screenWidth * 0.8, // Responsive image width
            height: screenHeight * 0.3, // Responsive image height
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  // Centered buttons builder
  Widget buildCenteredButtons(double screenWidth) {
    return Column(
      children: [
        buildTakePictureButton(screenWidth),
        const SizedBox(height: 20.0),
        buildImageFromGalleryButton(screenWidth),
        const SizedBox(height: 20.0),
        buildFromScratchButton(screenWidth),
      ],
    );
  }

  // Take picture button builder
  Widget buildTakePictureButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.6, // Responsive button width
      height: 50,
      child: ElevatedButton(
        onPressed: goToTakeAPicture,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Take a picture", style: TextStyle(fontSize: 20)),
            SizedBox(width: 4.0),
            Icon(Icons.camera_alt, size: 20.0),
          ],
        ),
      ),
    );
  }

  // Image from gallery button builder
  Widget buildImageFromGalleryButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.7, // Responsive button width
      height: 50,
      child: ElevatedButton(
        onPressed: goToImageFromGallery,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Image from gallery", style: TextStyle(fontSize: 20)),
            SizedBox(width: 4.0),
            Icon(Icons.image, size: 20.0),
          ],
        ),
      ),
    );
  }

  // From scratch button builder
  Widget buildFromScratchButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.7, // Responsive button width
      height: 50,
      child: ElevatedButton(
        onPressed: goToFromScratch,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("From Scratch", style: TextStyle(fontSize: 20)),
            SizedBox(width: 4.0),
            Icon(Icons.edit, size: 20.0),
          ],
        ),
      ),
    );
  }

  // Navigate to take a picture function
  void goToTakeAPicture() {
    debugPrint("Navigating to take a picture...");
  }

  // Navigate to image from gallery function
  void goToImageFromGallery() {
    debugPrint("Navigating to image from gallery...");
  }

  // Navigate to gameplay function
  void goToFromScratch() {
    debugPrint("Navigating to gameplay...");
  }
}
