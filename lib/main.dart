import 'package:creative_blogger_app/screens/loading.dart';
import 'package:creative_blogger_app/screens/login.dart';
import 'package:creative_blogger_app/screens/main_screen_with_bottom_app_bar.dart';
import 'package:creative_blogger_app/screens/post.dart';
import 'package:creative_blogger_app/screens/profile.dart';
import 'package:creative_blogger_app/screens/register/email_screen.dart';
import 'package:creative_blogger_app/screens/register/password_screen.dart';
import 'package:creative_blogger_app/screens/register/terms.dart';
import 'package:creative_blogger_app/screens/register/username_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connection_notifier/connection_notifier.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

// ignore: constant_identifier_names
const API_URL = "https://api.creativeblogger.org";

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ConnectionNotifier(
      alignment: AlignmentDirectional.bottomCenter,
      child: MaterialApp(
        title: 'Creative Blogger',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        initialRoute: '/',
        navigatorKey: navigatorKey,
        routes: {
          LoadingScreen.routeName: (context) => const LoadingScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          MainScreenWithBottomAppBar.routeName: (context) =>
              const MainScreenWithBottomAppBar(),
          ChooseUsernameScreen.routeName: (context) =>
              const ChooseUsernameScreen(),
          TermsScreen.routeName: (context) => const TermsScreen(),
          ChooseEmailScreen.routeName: (context) => const ChooseEmailScreen(),
          ChoosePasswordScreen.routeName: (context) =>
              const ChoosePasswordScreen(),
          PostScreen.routeName: (context) => const PostScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen()
        },
        supportedLocales: const [
          Locale("en"),
          Locale("fr"),
          Locale("it"),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
