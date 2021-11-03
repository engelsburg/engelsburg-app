import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key, this.code = ""}) : super(key: key);

  final String code;

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  static final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _codeController.clear();
    _codeController.text = widget.code;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.resetPassword),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.code,
                  prefixIcon: const Icon(Icons.lock_outline),
                ),
              ),
              Container(
                height: 64.0,
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_codeController.text.isEmpty) return;

                    (await ApiService.verifyEmail(
                            context, _codeController.text.trim()))
                        .handle(
                      context,
                      onSuccess: (_) {
                        _codeController.clear();
                        ApiService.refreshJWT(context,
                            Provider.of<AuthModel>(context, listen: false));
                        ApiService.show(
                            context,
                            AppLocalizations.of(context)!
                                .emailSuccessfulVerified);
                        Navigator.pop(context);
                      },
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.verifyEmail),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
