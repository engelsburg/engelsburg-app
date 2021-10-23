import 'package:engelsburg_app/src/constants/api_constants.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/dto/auth_info_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/dto/sign_in_request_dto.dart';
import 'package:engelsburg_app/src/pages/user/oauth_login_page.dart';
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
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                AppLocalizations.of(context)!.emailPassword,
                textAlign: TextAlign.start,
                textScaleFactor: 1.5,
              ),
            ),
            Form(
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
                        if (_obscured == false)
                          setState(() => _obscured = true);
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
                              ApiService.show(context,
                                  AppLocalizations.of(context)!.loggedIn);
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
                  Container(
                    padding: const EdgeInsets.only(top: 24),
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.or,
                      textScaleFactor: 1.4,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 24),
                    height: 60,
                    width: 300,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 1, color: Colors.black),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Image(
                                image: AssetImage(
                                    'assets/images/oauth/google_logo.png')),
                            Container(
                              padding: EdgeInsets.only(left: 16),
                              width: 240,
                              height: 28,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .signUpWithGoogle,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onPressed: () async {
                        final auth = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OauthLoginPage(
                                    url: ApiConstants
                                        .engelsburgApiOAuthGoogleLoginUrl)));

                        if (auth == null) return;
                        if (auth is AuthInfoDTO) {
                          if (auth.validate) {
                            authProvider.setTokenPair(
                                accessToken: auth.token!,
                                refreshToken: auth.refreshToken!);
                            ApiService.show(context,
                                AppLocalizations.of(context)!.loggedIn);
                            Navigator.pop(context);
                          } else {
                            ApiService.show(
                                context,
                                AppLocalizations.of(context)!
                                    .unexpectedErrorMessage);
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
