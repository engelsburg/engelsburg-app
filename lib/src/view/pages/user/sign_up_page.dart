import 'package:engelsburg_app/src/models/api/dto/auth_info_dto.dart';
import 'package:engelsburg_app/src/models/api/dto/sign_up_request_dto.dart';
import 'package:engelsburg_app/src/models/provider/auth.dart';
import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/utils/constants/api_constants.dart';
import 'package:engelsburg_app/src/utils/constants/asset_path_constants.dart';
import 'package:engelsburg_app/src/view/pages/user/oauth_login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static final _substitutionPlanPasswordFormKey = GlobalKey<FormState>();
  static final _emailAndPasswordFormKey = GlobalKey<FormState>();
  static var currentStep = 0;

  static final _schoolTokenTextController = TextEditingController();
  static final _emailTextController = TextEditingController();
  static final _passwordTextController = TextEditingController();

  bool _obscured = true;

  List<Step> steps(AuthModel authProvider) {
    return [
      Step(
          title: Text(AppLocalizations.of(context)!.substitutesPassword),
          subtitle: Text(AppLocalizations.of(context)!.verifyUserIsStudent),
          content: Form(
            key: _substitutionPlanPasswordFormKey,
            child: TextFormField(
              validator: (input) => input == null || input.isEmpty
                  ? AppLocalizations.of(context)!.fieldCantBeEmptyError
                  : null,
              controller: _schoolTokenTextController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: AppLocalizations.of(context)!.substitutesPassword,
              ),
            ),
          )),
      Step(
        title: Text(AppLocalizations.of(context)!.emailPassword),
        content: Form(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.noPasswordSpecified;
                    } else if (!value.contains(RegExp(r"[0-9a-zäöüA-ZÄÖÜ]"))) {
                      return AppLocalizations.of(context)!
                          .passwordMustContainNumber;
                    } else if (value.length < 8) {
                      return AppLocalizations.of(context)!.passwordMin8Chars;
                    }
                  },
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
                    if (!_emailAndPasswordFormKey.currentState!.validate()) {
                      return;
                    }

                    (await ApiService.signUp(context,
                            dto: SignUpRequestDTO(
                              schoolToken:
                                  _schoolTokenTextController.text.trim(),
                              email: _emailTextController.text.trim(),
                              password: _passwordTextController.text.trim(),
                            )))
                        .handle<AuthInfoDTO>(
                      context,
                      parse: (json) => AuthInfoDTO.fromJson(json),
                      onSuccess: (auth) {
                        if (auth!.validate) {
                          authProvider.set(auth);
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
                        if (error.isForbidden &&
                            error.extra == 'school_token') {
                          ApiService.show(
                              context,
                              AppLocalizations.of(context)!
                                  .wrongSubstituteKeyError);
                          setState(() => currentStep = 0);
                        } else if (error.isInvalidParam) {
                          ApiService.show(context,
                              AppLocalizations.of(context)!.invalidEmailError);
                        } else if (error.isAlreadyExisting) {
                          ApiService.show(
                              context,
                              AppLocalizations.of(context)!
                                  .accountAlreadyExistingError);
                        } else {
                          ApiService.show(
                              context,
                              AppLocalizations.of(context)!
                                  .unexpectedErrorMessage);
                        }
                      },
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.signUp),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthModel>(context);
    return Scaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 0),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.lock),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                  child: Text(AppLocalizations.of(context)!.dataDisclaimer),
                ),
              ),
            ],
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.signUp),
      ),
      body: ListView(
        children: [
          Stepper(
            physics: const ClampingScrollPhysics(),
            currentStep: currentStep,
            onStepContinue: currentStep == steps(authProvider).length - 1
                ? null
                : () {
                    final canGoToStep2 = currentStep == 0
                        ? _substitutionPlanPasswordFormKey.currentState!
                            .validate()
                        : true;

                    if (canGoToStep2) {
                      setState(() {
                        currentStep = currentStep + 1;
                      });
                    }
                  },
            onStepCancel: currentStep == 0
                ? null
                : () {
                    setState(() {
                      currentStep = currentStep - 1;
                    });
                  },
            steps: steps(authProvider),
          ),
          if (currentStep == 1)
            Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.or,
                    textScaleFactor: 1.4,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  height: 60,
                  width: 300,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
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
                          const Image(image: AssetImage(AssetPaths.googleLogo)),
                          Container(
                            padding: const EdgeInsets.only(left: 16),
                            width: 240,
                            height: 28,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                AppLocalizations.of(context)!.signUpWithGoogle,
                                style: const TextStyle(fontSize: 18),
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
                              builder: (context) => OauthLoginPage(
                                  url: ApiConstants
                                      .engelsburgApiOAuthGoogleLoginUrl,
                                  schoolToken:
                                      _schoolTokenTextController.text.trim())));

                      if (auth == null) return;
                      if (auth is Result) {
                        auth.handle<AuthInfoDTO>(
                          context,
                          parse: (json) => AuthInfoDTO.fromJson(json),
                          onError: (error) {
                            if (error.isForbidden &&
                                error.extra == 'school_token') {
                              ApiService.show(
                                  context,
                                  AppLocalizations.of(context)!
                                      .wrongSubstituteKeyError);
                              setState(() => currentStep = 0);
                              return;
                            }
                          },
                          onSuccess: (auth) {
                            if (auth!.validate) {
                              authProvider.set(auth);
                              ApiService.show(context,
                                  AppLocalizations.of(context)!.loggedIn);
                              Navigator.pop(context);
                              return;
                            }
                          },
                        );
                      } else {
                        ApiService.show(
                            context,
                            AppLocalizations.of(context)!
                                .unexpectedErrorMessage);
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
