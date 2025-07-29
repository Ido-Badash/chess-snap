import "package:chess_snap/features/home/home_view.dart";
import 'package:chess_snap/features/about_n_help/about_n_help_view.dart';
import "package:flutter/material.dart";

class ChessSnap extends StatefulWidget {
  const ChessSnap({super.key});

  @override
  State<ChessSnap> createState() => _ChessSnapState();
}

class _ChessSnapState extends State<ChessSnap> {
  Widget currentBody = const HomeView(); // default body

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // puts the body behind the AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // remove shadow for full transparency
        leading: IconButton(
          color: (currentBody.runtimeType == HomeView)
              ? Colors.white
              : Colors.black,
          onPressed: () {
            showAppMenu(context);
          },
          icon: const Icon(Icons.menu),
        ),
      ),
      body: currentBody, // update the body
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
            if (currentBody.runtimeType != AboutNHelpView)
              buildMenuTile(
                context,
                icon: Icons.help_outline,
                title: "About & Help",
                onTap: () {
                  setState(() {
                    currentBody =
                        const AboutNHelpView(); // change body to About & Help
                  });
                },
              ),
            const SizedBox(height: 50), // add space
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
        Navigator.pop(context); // close the menu
        onTap(); // update the body
      },
    );
  }
}
