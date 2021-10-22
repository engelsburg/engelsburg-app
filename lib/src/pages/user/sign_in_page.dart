import 'package:engelsburg_app/src/models/engelsburg_api/dto/auth_info_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/dto/sign_in_request_dto.dart';
import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  static final _emailAndPasswordFormKey = GlobalKey<FormState>();

  static final _emailTextController = TextEditingController();
  static final _passwordTextController = TextEditingController();

  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signIn),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _emailAndPasswordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailTextController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.email,
                  prefixIcon: const Icon(Icons.mail),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextFormField(
                  controller: _passwordTextController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscured,
                  onChanged: (text) {
                    if (_obscured == false) setState(() => _obscured = true);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context)!.password,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: GestureDetector(
                        onTap: () => setState(() => _obscured = !_obscured),
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
                    (await ApiService.signIn(context,
                            dto: SignInRequestDTO(
                              email: _emailTextController.text.trim(),
                              password: _passwordTextController.text.trim(),
                            )))
                        .handle<AuthInfoDTO>(
                      context,
                      parse: (json) => AuthInfoDTO.fromJson(json),
                      onSuccess: (auth) {
                        if (auth!.validate) {
                          authProvider.setTokenPair(
                              accessToken: auth.token!,
                              refreshToken: auth.refreshToken!);
                          ApiService.show(
                              context, AppLocalizations.of(context)!.loggedIn);
                          Navigator.pop(context);
                        } else {
                          ApiService.show(
                              context,
                              AppLocalizations.of(context)!
                                  .unexpectedErrorMessage);
                        }
                      },
                      onError: (error) {
                        if (error.isNotFound && error.extra == "user") {
                          ApiService.show(context,
                              AppLocalizations.of(context)!.userNotFound);
                        } else if (error.isForbidden &&
                            error.extra == "wrong_password") {
                          ApiService.show(context,
                              AppLocalizations.of(context)!.wrongPassword);
                        } else if (error.isInvalidParam) {
                          if (error.extra.contains("email")) {
                            ApiService.show(
                                context,
                                AppLocalizations.of(context)!
                                    .invalidEmailError);
                          } else {
                            ApiService.show(
                                context,
                                AppLocalizations.of(context)!
                                    .noPasswordSpecified);
                          }
                        } else {
                          ApiService.show(
                              context,
                              AppLocalizations.of(context)!
                                  .unexpectedErrorMessage);
                        }
                      },
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.signIn),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
