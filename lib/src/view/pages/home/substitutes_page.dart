import 'package:engelsburg_app/src/controller/substitute_controller.dart';
import 'package:engelsburg_app/src/models/provider/auth.dart';
import 'package:engelsburg_app/src/models/provider/substitute.dart';
import 'package:engelsburg_app/src/view/widgets/locked.dart';
import 'package:engelsburg_app/src/view/widgets/substitute_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SubstitutesPage extends StatefulWidget {
  const SubstitutesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubstitutesPageState();
}

class _SubstitutesPageState extends State<SubstitutesPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;
  late final SubstituteController _substituteController;
  static int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(initialIndex: tabIndex, length: 2, vsync: this);
    _pageController = PageController(initialPage: tabIndex);
    _substituteController = SubstituteController(setStateCallback: setState);

    if (context.read<AuthModel>().isLoggedIn) {
      _substituteController.updateSubstitutes(
          context, context.read<SubstituteSettings>());
      _substituteController.updateSubstituteMessages(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<AuthModel, bool>(
      selector: (context, auth) => auth.isLoggedIn,
      builder: (context, loggedIn, child) =>
          loggedIn ? _buildPage(context) : const LockedScreen(),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      appBar: TabBar(
        indicatorColor: Theme.of(context).textTheme.bodyText1!.color,
        labelColor: Theme.of(context).textTheme.bodyText1!.color,
        onTap: (index) {
          tabIndex = index;
          _tabController.index = index;
          _pageController.animateToPage(index,
              duration: kTabScrollDuration, curve: Curves.ease);
        },
        controller: _tabController,
        tabs: [
          Tab(text: AppLocalizations.of(context)!.substitutes),
          Tab(text: AppLocalizations.of(context)!.substituteMessages),
        ],
      ),
      body: Consumer<SubstituteSettings>(
        builder: (context, settings, child) {
          String locale = Localizations.localeOf(context).languageCode;
          DateFormat formatter = DateFormat('EEEE dd.MM.', locale);

          return PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              _buildSubstituteTab(formatter, settings),
              _buildSubstituteMessageTab(formatter),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSubstituteTab(
      DateFormat formatter, SubstituteSettings settings) {
    var substitutes = _substituteController.substitutes;
    int addedSubstituteDates = 0;

    return RefreshIndicator(
      child: substitutes.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) {
                bool addText = index != 0 &&
                    substitutes[index - 1].date == substitutes[index].date;
                if (addText) addedSubstituteDates++;

                return Container(
                  child: addText
                      ? SubstituteCard(substitute: substitutes[index])
                      : Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    formatter.format(substitutes[index].date!),
                                    textScaleFactor: 2,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                )),
                            SubstituteCard(substitute: substitutes[index])
                          ],
                        ),
                );
              },
              itemCount: substitutes.length + addedSubstituteDates,
              padding: const EdgeInsets.all(10),
              separatorBuilder: (_, __) => Container(height: 10),
            )
          : ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Text(AppLocalizations.of(context)!.noSubstitutes),
                  ),
                ),
              ],
            ),
      onRefresh: () =>
          _substituteController.updateSubstitutes(context, settings),
    );
  }

  Widget _buildSubstituteMessageTab(DateFormat formatter) {
    var substituteMessages = _substituteController.substituteMessages;
    return RefreshIndicator(
      child: substituteMessages.isNotEmpty
          ? ListView.separated(
              itemBuilder: (context, index) => SubstituteMessageCard(
                substituteMessage: substituteMessages[index],
                formatter: formatter,
              ),
              padding: const EdgeInsets.all(10),
              separatorBuilder: (context, index) => Container(height: 10),
              itemCount: substituteMessages.length,
            )
          : ListView(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Text(
                        AppLocalizations.of(context)!.noSubstituteMessages),
                  ),
                ),
              ],
            ),
      onRefresh: () => _substituteController.updateSubstituteMessages(context),
    );
  }
}
