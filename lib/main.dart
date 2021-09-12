import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/app.dart';
import 'src/provider/auth.dart';
import 'src/provider/theme.dart';
import 'src/services/shared_prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeChanger()),
        ChangeNotifierProvider(create: (context) => AuthModel()),
      ],
      child: const EngelsburgApp(),
    ),
  );
}
