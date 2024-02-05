import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/helper/user_session/auth.dart';
import 'package:social_app/helper/user_session/login_or_register.dart';
import 'package:social_app/pages/home_page.dart';
import 'package:social_app/pages/bookmark_page.dart';
import 'package:social_app/pages/profile_page.dart';
import 'package:social_app/pages/settings_page.dart';
import 'package:social_app/pages/users_page.dart';
import 'package:social_app/provider/bookmarks_provider.dart';
import 'package:social_app/provider/comments_povider.dart';
import 'package:social_app/provider/login_register_provider.dart';
import 'package:social_app/provider/posts_provider.dart';
import 'package:social_app/provider/profile_provider.dart';
import 'package:social_app/utils/routes/myroutes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:social_app/provider/theme_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => PostsProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),
        ChangeNotifierProvider(create: (context) => CommentsProvider()),
        ChangeNotifierProvider(create: (context) => BookmarkProvider()),
        ChangeNotifierProvider(create: (context) => LoginRegisterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return MaterialApp(
          home: const AuthPage(),
          theme: Provider.of<ThemeProvider>(context).themeData,
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          routes: {
            MyRoutes.homePage: (context) => const HomePage(),
            MyRoutes.usersPage: (context) => const UsersPage(),
            MyRoutes.profilePage: (context) => const ProfilePage(),
            MyRoutes.bookmarkPage: (context) => const BookmarkPage(),
            MyRoutes.settingsPage: (context) => const SettingsPage(),
            MyRoutes.loginOrRegisterPage: (context) => const LoginOrRegister(),
          },
        );
      },
    );
  }
}
