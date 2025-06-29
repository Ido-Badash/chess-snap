import "package:chess_snap/features/home/home_view.dart";
import "package:chess_snap/features/settings/presentation/settings_view.dart";
import 'package:chess_snap/features/about_n_help/about_n_help_view.dart';
import "package:flutter/material.dart";

class ChessSnap extends StatefulWidget {
  const ChessSnap({super.key});

  @override
  State<ChessSnap> createState() => _ChessSnapState();
}

class _ChessSnapState extends State<ChessSnap> {
  Widget currentBody = const HomeView(); // Default body is HomeView

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            showAppMenu(context); // Show menu as a modal
          },
          icon: const Icon(Icons.menu),
        ),
        title: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              setState(() {
                currentBody = const HomeView(); // Reset to HomeView
              });
            },
            style: ButtonStyle(
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              textStyle: WidgetStateProperty.all(
                const TextStyle(fontSize: 24),
              ),
            ),
            child: const Text("ChessSnap"),
          ),
        ),
      ),
      body: currentBody, // Dynamically update the body
    );
  }

  void showAppMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (currentBody.runtimeType != HomeView)
              buildMenuTile(
                context,
                icon: Icons.home,
                title: "Home",
                onTap: () {
                  setState(() {
                    currentBody = const HomeView(); // Change body to HomeView
                  });
                },
              ),
            if (currentBody.runtimeType != SettingsView)
              buildMenuTile(
                context,
                icon: Icons.settings,
                title: "Settings",
                onTap: () {
                  setState(() {
                    currentBody =
                        const SettingsView(); // Change body to SettingsView
                  });
                },
              ),
            if (currentBody.runtimeType != AboutNHelpView)
              buildMenuTile(
                context,
                icon: Icons.help_outline,
                title: "About & Help",
                onTap: () {
                  setState(() {
                    currentBody =
                        const AboutNHelpView(); // Change body to About & Help
                  });
                },
              ),
            const SizedBox(height: 50), // Add some spacing
          ],
        );
      },
    );
  }

  Widget buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close the menu
        onTap(); // Update the body
      },
    );
  }
}
