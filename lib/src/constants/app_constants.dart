import 'package:engelsburg_app/src/pages/cateteria_page.dart';
import 'package:engelsburg_app/src/pages/news_page.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static const appDescription =
      'Eine App, die Informationen über das Engelsburg-Gymnasium übersichtlich zusammenstellt.\n\nEntwickelt von den Schülern Paul Huerkamp (Backend) und Dario Trombello (Frontend bzw. Android & iOS App)';
  static const events = 'Termine';
  static const settings = 'Einstellungen';
  static const about = 'Über';
  static const bottomNavigationBarItems = [
    BottomNavigationBarItem(label: 'News', icon: Icon(Icons.library_books)),
    BottomNavigationBarItem(
        label: 'Cafeteria', icon: Icon(Icons.restaurant_menu)),
  ];
  static const bottomNavigationBarPages = <Widget>[
    NewsPage(),
    CafeteriaPage(),
  ];
  static const openInBrowser = 'Im Browser öffnen';
  static const share = 'Teilen';
  static const info = 'Info';
  static const location = 'Standort';
  static const schoolName = 'Engelsburg-Gymnasium';
  static const schoolAddress = 'Richardweg 3, 34117 Kassel';
  static const aboutTheSchool = 'Über die Schule';
  static const schoolDescription =
      'Das Engelsburg-Gymnasium ist ein staatlich anerkanntes katholisches Gymnasium in Trägerschaft des Ordens der Schwestern der heiligen Maria Magdalena Postel (SMMP). Es ist ausgezeichnet mit dem Gütesiegel „Hochbegabtenförderung“ des Landes Hessen. An der Schule werden die Schulformen G8 und G9 parallel unterrichtet.';
  static const schoolDescriptionSourceUrl =
      'https://www1.kassel.de/verzeichnisse/schulen/gymnasiale-oberstufen-und-gymnasien/engelsburg.php';
  static const schoolDescriptionSourceDomain = 'kassel.de';
  static const callPforte = 'Pforte anrufen';
  static const pforteNumber = '+49561789670';
  static const callSekretariat = 'Sekretariat anrufen';
  static const sekretariatNumber = '+495617896727';
  static const emailToSekretariat = 'E-Mail an das Sekretariat';
  static const sekretariatEmail = 'sekretariat@engelsburg.smmp.de';
  static const colorScheme = 'Farbschema';
  static const systemSetting = 'Systemeinstellung';
  static const dark = 'Dunkel';
  static const light = 'Hell';
  static const primaryColor = 'Primäre Farbe';
  static const selectPrimaryColor = 'Primäre Farbe auswählen';
  static const tapHereToChangePrimaryColor =
      'Tippe hier, um die primäre Farbe zu ändern';
  static const secondaryColor = 'Sekundäre Farbe';
  static const selectSecondaryColor = 'Sekundäre Farbe auswählen';
  static const tapHereToChangeSecondaryColor =
      'Tippe hier, um die sekundäre Farbe zu ändern';
  static const cancel = 'Abbrechen';
  static const reset = 'Zurücksetzen';
  static const loadingAppName = 'Lade App-Namen...';
  static const loadingAppVersion = 'Lade App-Version...';
  static const rateApp = 'App bewerten';
  static const appStoreUrl =
      'https://apps.apple.com/app/engelsburg-app/id1529725542';
  static const playStoreUrl =
      'https://play.google.com/store/apps/details?id=de.dariotrombello.engelsburg_app';
  static const sourceCodeOnGitHub = 'Quellcode auf GitHub';
  static const githubUrl = 'https://github.com/engelsburg';
  static const sendDarioAnEmail = 'Schreibe Dario eine E-Mail';
  static const darioEmail = 'info@dariotrombello.com';
  static const openSourceLicenses = 'Open-Source-Lizenzen';
  static const source = 'Quelle';
  static const dataOfSolarPanel = 'Daten der Solaranlage';
  static const unexpectedError = 'Ein unerwarteter Fehler ist aufgetreten. Bitte versuchen sie es ein wenig später erneut.';
  static const error = 'Fehler';

}
