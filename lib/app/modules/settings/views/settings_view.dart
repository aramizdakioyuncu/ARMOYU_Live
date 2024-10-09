import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RawScrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                controller: controller,
                child: ListView(
                  controller: controller,
                  children: const [
                    ListTile(
                      title: Text(
                        "User Settings",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text("Privacy & Safety"),
                    ),
                    ListTile(
                      title: Text("Authoried Apps"),
                    ),
                    ListTile(
                      title: Text("Connections"),
                    ),
                    ListTile(
                      title: Text(
                        "Billing settings",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text("ARMOYU Turbo"),
                    ),
                    ListTile(
                      title: Text("Server Turbo"),
                    ),
                    ListTile(
                      title: Text("Gift Inventory"),
                    ),
                    ListTile(
                      title: Text("Billing"),
                    ),
                    ListTile(
                      title: Text(
                        "App settings",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text("Voice & Video"),
                    ),
                    ListTile(
                      title: Text("Text & Images"),
                    ),
                    ListTile(
                      title: Text("Apperance"),
                    ),
                    ListTile(
                      title: Text("Notifitaions"),
                    ),
                    ListTile(
                      title: Text("Key Bindings"),
                    ),
                    ListTile(
                      title: Text("Languange"),
                    ),
                    ListTile(
                      title: Text("Windows/Mac/Linux Settings"),
                    ),
                    ListTile(
                      title: Text("Streamer Mode"),
                    ),
                    ListTile(
                      title: Text(
                        "Gaming Settings",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text("Game Activity"),
                    ),
                    ListTile(
                      title: Text("Overlay"),
                    ),
                    ListTile(
                      title: Text("Change Log"),
                    ),
                    ListTile(
                      title: Text("HypeSquad"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: Column(),
          ),
        ],
      ),
    );
  }
}
