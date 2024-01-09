import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/components/back_button.dart';
import 'package:social_app/components/my_button.dart';
import 'package:social_app/theme/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
                  child: MyBackButton(),
                ),
                SizedBox(
                  width: 55,
                ),
                Text(
                  "S E T T I N G S",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: MyButton(
                text: "Theme",
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false).toggleThemes();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
