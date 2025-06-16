import "package:flutter/material.dart";

class ChessSnap extends StatefulWidget {
  const ChessSnap({super.key});

  @override
  State<ChessSnap> createState() => _ChessSnapState();
}

class _ChessSnapState extends State<ChessSnap> {
  bool _menuOpen = false; // State variable to track menu expansion

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              _menuOpen = !_menuOpen;
            });
          },
          icon: const Icon(Icons.menu),
        ),
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text("ChessSnap"),
        ),
      ),
      body: Column(
        children: [
          if (_menuOpen) buildAppMenu(), // Show menu if open
          Flexible(flex: 1, child: buildAppDescription()),
          Flexible(flex: 1, child: buildCenteredButtons()),
        ],
      ),
    );
  }

  // App description builder
  Widget buildAppDescription() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          "TODO: ADD A DESCRIPTION OF THE APP HERE",
          // TODO: ADD A DESCRIPTION OF THE APP HERE
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // App menu builder
  Widget buildAppMenu() {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: goToSettings,
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text("About & Help"),
            onTap: goToAboutAndHelp,
          ),
        ],
      ),
    );
  }

  // Centered buttons builder
  Widget buildCenteredButtons() {
    return Column(
      children: [
        buildTakePictureButton(),
        const SizedBox(height: 12.0),
        buildImageFromGalleryButton(),
        const SizedBox(height: 12.0),
        buildFromScratchButton(),
      ],
    );
  }

  Widget buildTakePictureButton() {
    return SizedBox(
      width: 220,
      child: ElevatedButton(
        onPressed: goToTakeAPicture,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Take a picture"),
            SizedBox(width: 4.0),
            Icon(Icons.camera_alt, size: 16.0),
          ],
        ),
      ),
    );
  }

  Widget buildImageFromGalleryButton() {
    return SizedBox(
      width: 220,
      child: ElevatedButton(
        onPressed: goToImageFromGallery,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Image from gallery"),
            SizedBox(width: 4.0),
            Icon(Icons.image, size: 16.0),
          ],
        ),
      ),
    );
  }

  Widget buildFromScratchButton() {
    return SizedBox(
      width: 220,
      child: ElevatedButton(
        onPressed: goToFromScratch,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("From Scratch"),
            SizedBox(width: 4.0),
            Icon(Icons.edit, size: 16.0),
          ],
        ),
      ),
    );
  }

  // Navigate to settings function
  void goToSettings() {
    // TODO: Implement the settings navigation logic
    debugPrint("Navigating to settings...");
  }

  // Navigate to about and help function
  void goToAboutAndHelp() {
    // TODO: Implement the about and help navigation logic
    debugPrint("Navigating to about and help...");
  }

  // Open menu function
  void openMenu() {
    // TODO: Implement the menu opening logic
    debugPrint("Menu opened");
  }

  // Navigate to take a picture function
  void goToTakeAPicture() {
    // TODO: Implement the take a picture logic
    debugPrint("Navigating to take a picture...");
  }

  // Navigate to image from gallery function
  void goToImageFromGallery() {
    // TODO: Implement the image from gallery logic
    debugPrint("Navigating to image from gallery...");
  }

  // Navigate to gameplay function
  void goToFromScratch() {
    // TODO: Implement the menu opening logic
    debugPrint("Navigating to gameplay...");
  }
}
