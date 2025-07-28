import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:solve_tutor/constants/app_constants.dart';
import 'package:solve_tutor/constants/state_index.dart';
import 'package:solve_tutor/constants/theme.dart';
import 'package:solve_tutor/splash_page.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

Future<void> main() async {
  initializeDateFormatting();
  WidgetsFlutterBinding.ensureInitialized();
  // initializeDateFormatting();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ——— Google Sign-In 7.x initialisation ———
  String? gClientId;
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    gClientId = DefaultFirebaseOptions.currentPlatform.iosClientId;
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    gClientId = DefaultFirebaseOptions.currentPlatform.androidClientId;
  } else {
    gClientId = null;                     // macOS, web, etc.
  }

  await GoogleSignIn.instance.initialize(
    clientId: gClientId,
    // serverClientId: null,              // add only if you need offline tokens
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MultiProvider(
        providers: stateIndex,
        child: MaterialApp(
          title: AppConstants.appTitle,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: primaryColor,
            primarySwatch: getMaterialColor(primaryColor),
            scaffoldBackgroundColor: Colors.grey.shade100,
            fontFamily: 'NotoSans',
          ),
          home: SplashPage(),
        ),
      );
    });
  }
}
