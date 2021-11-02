import 'package:engelsburg_app/src/provider/notification.dart';
import 'package:engelsburg_app/src/provider/substitute.dart';
import 'package:engelsburg_app/src/services/db_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/provider/auth.dart';
import 'src/provider/theme.dart';
import 'src/services/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPrefs.init();
  await DatabaseService.init();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeChanger()),
        ChangeNotifierProvider(create: (context) => AuthModel()),
        ChangeNotifierProvider(create: (context) => SubstituteSettings()),
        ChangeNotifierProvider(
          create: (context) => NotificationSettings(),
        )
      ],
      child: const EngelsburgApp(),
    ),
  );
}
