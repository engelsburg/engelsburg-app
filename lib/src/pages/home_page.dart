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
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: AppConstants.bottomNavigationBarItems,
        onTap: (index) {
          setState(() => _currentPage = index);
          _pageController.jumpToPage(_currentPage);
        },
      ),
      body: PageView(
        controller: _pageController,
        children: AppConstants.bottomNavigationBarPages,
      ),
    );
  }
}
