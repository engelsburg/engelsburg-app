import 'package:engelsburg_app/src/models/provider/theme.dart';
import 'package:engelsburg_app/src/utils/global_context.dart';
import 'package:engelsburg_app/src/view/pages/home/grades_page.dart';
import 'package:engelsburg_app/src/view/pages/home/home_page.dart';
import 'package:engelsburg_app/src/view/pages/home/news_page.dart';
import 'package:engelsburg_app/src/view/pages/home/substitutes_page.dart';
import 'package:engelsburg_app/src/view/pages/home/timetable_page.dart';
import 'package:engelsburg_app/src/view/pages/settings/notifications_settings_page.dart';
import 'package:engelsburg_app/src/view/pages/settings/settings_page.dart';
import 'package:engelsburg_app/src/view/pages/settings/substitutes_settings_page.dart';
import 'package:engelsburg_app/src/view/pages/settings/theme_settings_page.dart';
import 'package:engelsburg_app/src/view/pages/user/account_page.dart';
import 'package:engelsburg_app/src/view/pages/user/reset_password_page.dart';
import 'package:engelsburg_app/src/view/pages/user/sign_in_page.dart';
import 'package:engelsburg_app/src/view/pages/user/sign_up_page.dart';
import 'package:engelsburg_app/src/view/pages/user/verify_email_page.dart';
import 'package:engelsburg_app/src/view/pages/util/about_page.dart';
import 'package:engelsburg_app/src/view/pages/util/about_school_page.dart';
import 'package:engelsburg_app/src/view/pages/util/cafeteria_page.dart';
import 'package:engelsburg_app/src/view/pages/util/events_page.dart';
import 'package:engelsburg_app/src/view/pages/util/solar_panel_page.dart';
import 'package:engelsburg_app/src/view/widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

/// The Widget that configures your application.
class EngelsburgApp extends StatelessWidget {
  const EngelsburgApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    return MaterialApp(
      navigatorKey: GlobalContext.key,
      builder: (context, child) =>
          ScrollConfiguration(behavior: NoOverscrollEffect(), child: child!),
      debugShowCheckedModeBanner: false,
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
        "/": (context) => const HomePage(),
        "/news": (context) => const NewsPage(),
        "/savedArticles": (context) => const SavedArticlesPage(),
        "/cafeteria": (context) => const CafeteriaPage(),
        "/timetable": (context) => const TimetablePage(),
        "/grades": (context) => const GradesPage(),
        "/substitutes": (context) => const SubstitutesPage(),
        "/settings/substitutes": (context) => const SubstitutesSettingsPage(),
        "/settings/theme": (context) => const ThemeSettingsPage(),
        "/settings/notifications": (context) =>
            const NotificationSettingsPage(),
        "/signUp": (context) => const SignUpPage(),
        "/signIn": (context) => const SignInPage(),
        "/account": (context) => const AccountPage(),
        "/account/advanced": (context) => const AccountAdvancedPage(),
        "/account/resetPassword": (context) => const ResetPasswordPage(),
        "/account/verifyEmail": (context) => const VerifyEmailPage(),
        "/solarPanel": (context) => const SolarPanelPage(),
        "/events": (context) => EventsPage(),
        "/settings": (context) => const SettingsPage(),
        "/about": (context) => const AboutPage(),
        "/aboutSchool": (context) => const AboutSchoolPage(),
      },
    );
  }
}
