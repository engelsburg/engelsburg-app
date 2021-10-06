import 'package:engelsburg_app/src/constants/app_constants.dart';
import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  var _currentPage = 0;
  bool _handledByNavBar = false;

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
          DrawerHeader(
            margin: EdgeInsets.zero,
            child: Text(AppLocalizations.of(context)!.appTitle),
          ),
          Consumer<AuthModel>(
            builder: (context, auth, child) => auth.isLoggedIn
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, "/register");
                            },
                            child: Text(AppLocalizations.of(context)!.singIn)),
                      ),
                      const Divider(height: 0),
                    ],
                  ),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: Text("Cafeteria"),
            onTap: () => Navigator.pushNamed(context, "/cafeteria"),
          ),
          ListTile(
            leading: const Icon(Icons.wb_sunny),
            title: Text(AppLocalizations.of(context)!.solarPanelData),
            onTap: () => Navigator.pushNamed(context, "/solarPanel"),
          ),
          ListTile(
            leading: const Icon(Icons.watch_later),
            title: Text(AppLocalizations.of(context)!.events),
            onTap: () => Navigator.pushNamed(context, "/events"),
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
      )),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        actions: [
          if (_currentPage == 4)
            IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, "/settings/substitutes"),
              icon: Icon(Icons.settings),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        currentIndex: _currentPage,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'News',
            icon: Icon(Icons.library_books),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.grades,
            icon: Icon(Icons.assessment),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.timetable,
            icon: Icon(Icons.apps_outlined),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.tasks,
            icon: Icon(Icons.assignment),
          ),
          BottomNavigationBarItem(
            label: AppLocalizations.of(context)!.substitutes,
            icon: Icon(Icons.dashboard),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentPage = index;
            _handledByNavBar = true;
          });
          _pageController.animateToPage(_currentPage,
              duration: Duration(milliseconds: 500), curve: Curves.decelerate);
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          if (!_handledByNavBar) {
            setState(() => _currentPage = index);
            _pageController.animateToPage(
              _currentPage,
              duration: Duration(milliseconds: 500),
              curve: Curves.decelerate,
            );
          } else if (_currentPage == index) _handledByNavBar = false;
        },
        children: AppConstants.bottomNavigationBarPages,
      ),
    );
  }
}
