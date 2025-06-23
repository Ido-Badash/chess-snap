import "package:chess_snap/features/home/presentation/view.dart";
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

  final Map views = {
    "home": HomeView(),
    "settings": SettingsView(),
    "about & help": AboutNHelpView(),
  };

  @override
  void initState() {
    super.initState();
    currentBody = views["home"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              toggleMenuState();
            });
          },
          icon: const Icon(Icons.menu),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              _goTo(views["home"]);
            },
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(
                Colors.transparent,
              ), // Remove hover color
              textStyle: WidgetStateProperty.all(
                const TextStyle(fontSize: 24),
              ), // Bigger text
            ),
            child: const Text("ChessSnap"),
          ),
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            currentBody ?? views["home"], // Render currentBody or home view
            if (_menuOpen)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withAlpha(
                    220,
                  ), // Optional background for menu
                  child: buildAppMenu(), // Menu on top
                ),
              ),
          ],
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
          ifNotOnViewThenTile("home", buildHomeTile()),
          ifNotOnViewThenTile("settings", buildSettingsTile()),
          ifNotOnViewThenTile("about & help", buildAboutNHelpTile()),
        ],
      ),
    );
  }

  // if not on view
  Widget ifNotOnViewThenTile(String view, Widget tile) {
    if (currentBody != views[view]) {
      return tile;
    }
    return const SizedBox.shrink();
  }

  // TILES
  Widget buildHomeTile() {
    return ListTile(
      leading: const Icon(Icons.home),
      title: const Text("Home"),
      onTap: () => goToHome(),
    );
  }

  Widget buildSettingsTile() {
    return ListTile(
      leading: const Icon(Icons.settings),
      title: const Text("Settings"),
      onTap: goToSettings,
    );
  }

  Widget buildAboutNHelpTile() {
    return ListTile(
      leading: const Icon(Icons.help_outline),
      title: const Text("About & Help"),
      onTap: goToAboutAndHelp,
    );
  }

  // Toggle menu state
  void toggleMenuState() {
    _menuOpen = !_menuOpen;
  }

  // Navigate to settings function
  void goToHome() {
    // Example navigation to a SettingsPage (replace with your actual settings page)
    _goTo(views["home"]);
    debugPrint("Navigating to home...");
  }

  // Navigate to settings function
  void goToSettings() {
    // Example navigation to a SettingsPage (replace with your actual settings page)
    _goTo(views["settings"]);
    debugPrint("Navigating to settings...");
  }

  // Navigate to about and help function
  void goToAboutAndHelp() {
    _goTo(views["about & help"]);
    debugPrint("Navigating to about and help...");
  }

  void _goTo(Widget widget) {
    setState(() {
      _menuOpen = false;
      currentBody = widget;
    });
  }
}
