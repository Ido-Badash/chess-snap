import "package:chess_snap/features/settings/presentation/view.dart";
import 'package:chess_snap/features/about_n_help/presentation/view.dart';
import "package:flutter/material.dart";

class ChessSnap extends StatefulWidget {
  const ChessSnap({super.key});

  @override
  State<ChessSnap> createState() => _ChessSnapState();
}

class _ChessSnapState extends State<ChessSnap> {
  bool _menuOpen = false; // State variable to track menu expansion
  Widget? currentBody;

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
          Expanded(
            child: Stack(
              children: [
                currentBody ??
                    buildAppHomeView(), // Render currentBody or home view
                if (_menuOpen)
                  buildAppMenu(), // Overlay menu on top of currentBody
              ],
            ),
          ),
        ],
      ),
    );
  }

  // App home view builder
  Widget buildAppHomeView() {
    return Column(
      children: [
        Flexible(flex: 1, child: buildAppDescription()),
        Flexible(flex: 1, child: buildCenteredButtons()),
      ],
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
          Container(width: double.infinity, height: 1, color: Colors.black.withAlpha(200),)
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

  // Take picture button builder
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

  // Image from gallery button builder
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

  // From scrach button builder
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
    // Example navigation to a SettingsPage (replace with your actual settings page)
    _goTo(SettingsView());
    debugPrint("Navigating to settings...");
  }

  // Navigate to about and help function
  void goToAboutAndHelp() {
    _goTo(AboutNHelpView());
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

  void _goTo(Widget widget) {
    setState(() {
      currentBody = widget;
    });
  }
}
