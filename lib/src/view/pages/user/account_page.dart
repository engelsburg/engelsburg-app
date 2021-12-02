import 'dart:convert';

import 'package:engelsburg_app/src/models/provider/auth.dart';
import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/view/widgets/error_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    AuthModel auth = Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountSettings),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(right: 8),
                        alignment: Alignment.centerLeft,
                        child: const Icon(Icons.account_circle, size: 80),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                auth.email ?? " ",
                                style: TextStyle(fontSize: 24),
                              ),
                            ),
                            const SizedBox(height: 12),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      auth.isVerified
                                          ? Icons.done
                                          : Icons.close_rounded,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    auth.isVerified
                                        ? AppLocalizations.of(context)!
                                            .emailVerified
                                        : AppLocalizations.of(context)!
                                            .emailNotVerified,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (!auth.isVerified)
                    ListTile(
                      onTap: () =>
                          Navigator.pushNamed(context, "/account/verifyEmail"),
                      leading: const Icon(Icons.email),
                      title: Text(AppLocalizations.of(context)!.verifyEmail),
                    ),
                ],
              ),
            ),
            const Divider(height: 10, thickness: 3),
            ListTile(
              leading: const Icon(Icons.vpn_key),
              title: Text(AppLocalizations.of(context)!.resetPassword),
              onTap: () =>
                  Navigator.pushNamed(context, "/account/resetPassword"),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logout),
              onTap: () {
                auth.clear();
                //TODO: remove device from notifications
                Navigator.pop(context);
              },
            ),
            ListTile(
              trailing: Icon(Icons.adaptive.arrow_forward),
              title: Text(AppLocalizations.of(context)!.advanced),
              onTap: () => Navigator.pushNamed(context, "/account/advanced"),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountAdvancedPage extends StatelessWidget {
  const AccountAdvancedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthModel auth = Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.advanced),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(
            leading: const Icon(Icons.analytics_outlined),
            title: Text(AppLocalizations.of(context)!.requestAccountData),
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AccountData()));
            },
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red, width: 3),
            ),
            child: ListTile(
              leading: const Icon(Icons.delete_forever),
              title: Text(AppLocalizations.of(context)!.deleteAccount),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(AppLocalizations.of(context)!.deleteAccount),
                      content: Text(
                          AppLocalizations.of(context)!.confirmDeleteAccount),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(AppLocalizations.of(context)!.cancel),
                        ),
                        TextButton(
                          child: Text(AppLocalizations.of(context)!.delete),
                          onPressed: () async {
                            (await ApiService.deleteAccount(context)).handle(
                              context,
                              onSuccess: (_) {
                                auth.clear();
                                Navigator.popUntil(
                                  context,
                                  (route) => route.isFirst,
                                );
                              },
                              onError: (error) {
                                ApiService.show(
                                  context,
                                  AppLocalizations.of(context)!
                                      .unexpectedErrorMessage,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccountData extends StatefulWidget {
  const AccountData({Key? key}) : super(key: key);

  static const encoder = JsonEncoder.withIndent('  ');

  @override
  State<AccountData> createState() => _AccountDataState();
}

class _AccountDataState extends State<AccountData>
    with AutomaticKeepAliveClientMixin<AccountData> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var prettyString = "";

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountData),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: prettyString)),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<Result>(
            future: ApiService.accountData(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!.build<Map<String, dynamic>>(
                  context,
                  parse: (json) => Result.keepJson(json),
                  onSuccess: (json) {
                    print(json);
                    prettyString = AccountData.encoder.convert(json);

                    return Text(prettyString);
                  },
                  onError: (error) {
                    return const ErrorBox();
                  },
                );
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
