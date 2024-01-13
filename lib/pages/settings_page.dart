import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("S E T T I N G S"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
              child: MyButton(
                text: "Theme",
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleThemes();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
