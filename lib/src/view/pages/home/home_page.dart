import 'package:engelsburg_app/src/models/provider/auth.dart';
import 'package:engelsburg_app/src/utils/constants/app_constants.dart';
import 'package:engelsburg_app/src/utils/constants/asset_path_constants.dart';
import 'package:engelsburg_app/src/view/widgets/locked.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentPage = 0;
  bool _handledByNavBar = false;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            Container(
              height: 100,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Image(image: AssetImage(AssetPaths.appLogo)),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.appTitle,
                      textScaleFactor: 1.5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Consumer<AuthModel>(
              builder: (context, auth, child) => auth.isLoggedIn
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ListTile(
                        leading: const Icon(Icons.account_circle_outlined),
                        title: Text("Account"),
                        onTap: () => Navigator.pushNamed(context, "/account"),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            AppLocalizations.of(context)!
                                .loginForAdvancedFeatures,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 8, right: 16),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, "/signUp");
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.signUp)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, bottom: 16, right: 16),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, "/signIn");
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.signIn)),
                        ),
                      ],
                    ),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text("Cafeteria"),
              onTap: () => Navigator.pushNamed(context, "/cafeteria"),
            ),
            ListTile(
              leading: const Icon(Icons.watch_later),
              title: Text(AppLocalizations.of(context)!.events),
              onTap: () => Navigator.pushNamed(context, "/events"),
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: Text(AppLocalizations.of(context)!.solarPanelData),
              onTap: () => Navigator.pushNamed(context, "/solarPanel"),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
              onTap: () => Navigator.pushNamed(context, "/settings"),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(AppLocalizations.of(context)!.about),
              onTap: () => Navigator.pushNamed(context, "/about"),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          if (_currentPage == 4)
            Locked(
              enforceVerified: false,
              child: IconButton(
                onPressed: () =>
                    Navigator.pushNamed(context, "/settings/substitutes"),
                icon: const Icon(Icons.settings),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: _currentPage,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            label: 'News',
            icon: Icon(Icons.library_books),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.grades,
            icon: const Icon(Icons.assessment),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.timetable,
            icon: const Icon(Icons.apps_outlined),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.tasks,
            icon: const Icon(Icons.assignment),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.substitutes,
            icon: const Icon(Icons.dashboard),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentPage = index;
            _handledByNavBar = true;
          });
          _pageController.animateToPage(_currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.decelerate);
        },
      ),
      body: PageView(
        allowImplicitScrolling: false,
        controller: _pageController,
        onPageChanged: (index) {
          if (!_handledByNavBar) {
            setState(() => _currentPage = index);
            _pageController.animateToPage(
              _currentPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.decelerate,
            );
          } else if (_currentPage == index) {
            _handledByNavBar = false;
          }
        },
        children: AppConstants.bottomNavigationBarPages,
      ),
    );
  }
}
