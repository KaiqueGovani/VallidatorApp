import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:vallidator/models/User.dart';
import 'package:vallidator/screens/AddTemplateScreen/add_template_screen.dart';
import 'package:vallidator/screens/DashboardScreen/dashboard_screen.dart';
import 'package:vallidator/screens/LoginScreen/login_screen.dart';
import 'package:vallidator/screens/MyAccountScreen/my_account_screen.dart';
import 'package:vallidator/screens/TemplatesScreen/templates_screen.dart';
import 'package:vallidator/screens/UsersScreen/users_screen.dart';
import 'package:vallidator/themes/main_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //Pass all uncaught fatal errors to Crashlytics.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: mainTheme,
      initialRoute: 'login',
      routes: {
        'login': (context) => LoginScreen(),
        'templates': (context) => const TemplatesScreen(),
        'add-template': (context) => const AddTemplateScreen(),
        'users': (context) => UsersScreen(),
        'dashboard': (context) => DashboardScreen(),
      },
      onGenerateRoute: (routeSettings) {
        if (routeSettings.name == 'my-account') {
          final arguments = routeSettings.arguments;
          if (arguments is Map<String, dynamic>) {
            final bool isAdmin = arguments['isAdmin'] ??
                false; // Default to false if not provided
            final User? edittingUser = arguments['edittingUser'];
            return MaterialPageRoute(builder: (context) {
              return MyAccountScreen(
                  isAdmin: isAdmin, edittingUser: edittingUser);
            });
          }
        }
        return null;
      },
    );
  }
}
