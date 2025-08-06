import "package:chess_snap/features/home/home_view.dart";
import 'package:chess_snap/features/about_n_help/about_n_help_view.dart';
import "package:flutter/material.dart";

class ChessSnap extends StatefulWidget {
  const ChessSnap({super.key});

  @override
  State<ChessSnap> createState() => _ChessSnapState();
}

class _ChessSnapState extends State<ChessSnap> with WidgetsBindingObserver {
  Widget currentBody = const HomeView(); // default body

  @override
  void initState() {
    super.initState();
    // Add this widget as an observer for app lifecycle changes
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Clean up when the widget is disposed
    WidgetsBinding.instance.removeObserver(this);
    _stopServer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        // App is being terminated
        debugPrint('App is being terminated, stopping server...');
        _stopServer();
        break;
      case AppLifecycleState.paused:
        // App is paused (minimized)
        debugPrint('App paused');
        break;
      case AppLifecycleState.resumed:
        // App is resumed
        debugPrint('App resumed');
        break;
      case AppLifecycleState.inactive:
        // App is inactive
        debugPrint('App inactive');
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        debugPrint('App hidden');
        break;
    }
  }

  void _stopServer() async {}

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
