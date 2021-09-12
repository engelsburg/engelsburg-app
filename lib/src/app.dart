import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'provider/theme.dart';

/// The Widget that configures your application.
class EngelsburgApp extends StatelessWidget {
  const EngelsburgApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      onGenerateTitle: (BuildContext context) =>
          AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData.from(
        colorScheme: const ColorScheme.light().copyWith(
          primary: themeChanger.primaryColor,
          secondary: themeChanger.secondaryColor,
        ),
      ),
      darkTheme: ThemeData.from(
        colorScheme: const ColorScheme.dark().copyWith(
          primary: themeChanger.primaryColor,
          secondary: themeChanger.secondaryColor,
        ),
      ),
      themeMode: themeChanger.themeMode,
      home: const HomePage(),
    );
  }
}
