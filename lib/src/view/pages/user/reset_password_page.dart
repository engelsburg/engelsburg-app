import 'package:engelsburg_app/src/models/api/dto/reset_password_dto.dart';
import 'package:engelsburg_app/src/models/provider/auth.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key, this.code = ""}) : super(key: key);

  final String code;

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  static final _codeController = TextEditingController();
  static final _passwordController = TextEditingController();

  bool _obscured = true;
  bool _requested = false;

  @override
  Widget build(BuildContext context) {
    AuthModel auth = Provider.of<AuthModel>(context);
    if (!_requested) {
      _passwordController.clear();
      _codeController.clear();
    }

    _codeController.text = widget.code;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.resetPassword),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          child: _requested
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Text(
                        AppLocalizations.of(context)!.passwordResetRequestEmail,
                        textAlign: TextAlign.center,
                        textScaleFactor: 1.25,
                      ),
                    ),
                    TextFormField(
                      controller: _codeController,
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.code,
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: TextFormField(
                        controller: _passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: _obscured,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.password,
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                            child: GestureDetector(
                              onTap: () =>
                                  setState(() => _obscured = !_obscured),
                              child: Icon(
                                  _obscured
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  size: 24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 64.0,
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          (await ApiService.resetPassword(
                            context,
                            ResetPasswordDTO(
                              auth.email,
                              _passwordController.text.trim(),
                              _codeController.text.trim(),
                            ),
                          ))
                              .handle(
                            context,
                            onSuccess: (_) {
                              ApiService.refreshJWT(context, auth);
                              _codeController.clear();
                              _passwordController.clear();
                              ApiService.show(
                                  context,
                                  AppLocalizations.of(context)!
                                      .passwordResetSuccessful);
                              Navigator.pop(context);
                            },
                            onError: (error) {
                              if (error.isNotFound && error.extra == "user") {
                                ApiService.show(context,
                                    AppLocalizations.of(context)!.userNotFound);
                              }
                            },
                          );
                        },
                        child:
                            Text(AppLocalizations.of(context)!.resetPassword),
                      ),
                    ),
                  ],
                )
              : Container(
                  height: 64.0,
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      (await ApiService.requestPasswordReset(
                              context, auth.email!))
                          .handle(
                        context,
                        onSuccess: (_) {
                          setState(() {
                            _requested = true;
                          });
                        },
                        onError: (error) {
                          if (error.isNotFound && error.extra == "user") {
                            ApiService.show(context,
                                AppLocalizations.of(context)!.userNotFound);
                          }
                        },
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.resetPassword),
                  ),
                ),
        ),
      ),
    );
  }
}
