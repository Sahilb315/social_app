import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/auth/auth.dart';
import 'package:social_app/auth/login_or_register.dart';
import 'package:social_app/pages/bookmark_page.dart';
import 'package:social_app/pages/home_page.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/pages/settings_page.dart';
import 'package:social_app/pages/users_page.dart';
import 'package:social_app/routes/myroutes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_app/theme/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthPage(),
      // debugShowMaterialGrid: true,
      // darkTheme: darkMode,
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
      routes: {
        MyRoutes.homePage: (context) => const HomePage(),
        MyRoutes.usersPage: (context) => const UsersPage(),
        MyRoutes.profilePage: (context) => ProfilePage(),
        MyRoutes.bookmarkPage: (context) => const BookmarkPage(),
        MyRoutes.settingsPage :(context) => const SettingsPage(),
        MyRoutes.loginOrRegisterPage :(context) =>const LoginOrRegister(),
        // MyRoutes.openPostPage :(context) =>  PostOpenPage(),
        // '/postPage' :(context) => const PostOpenPage(docID: '', likes: [], username: '', useremail: '', dateTime: ,)
      },
    );
  }
}
