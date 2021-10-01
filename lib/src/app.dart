import 'package:engelsburg_app/src/pages/about_page.dart';
import 'package:engelsburg_app/src/pages/about_school_page.dart';
import 'package:engelsburg_app/src/pages/cafeteria_page.dart';
import 'package:engelsburg_app/src/pages/events_page.dart';
import 'package:engelsburg_app/src/pages/news_page.dart';
import 'package:engelsburg_app/src/pages/register_page.dart';
import 'package:engelsburg_app/src/pages/settings_page.dart';
import 'package:engelsburg_app/src/pages/solar_panel_page.dart';
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
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/news": (context) => NewsPage(),
        "/savedArticles": (context) => SavedArticlesPage(),
        "/cafeteria": (context) => CafeteriaPage(),
        //"/timetable": (context) => TimetablePage(),
        //"/grades": (context) => GradesPage(),
        //"/substitutes": (context) => SubstitutesPage(),
        "/register": (context) => RegisterPage(),
        "/solarPanel": (context) => SolarPanelPage(),
        "/events": (context) => EventsPage(),
        "/settings": (context) => SettingsPage(),
        "/about": (context) => AboutPage(),
        "/aboutSchool": (context) => AboutSchoolPage(),
      },
    );
  }
}
