import 'package:engelsburg_app/src/models/engelsburg_api/auth_info_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/sign_up_request_dto.dart';
import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                border: OutlineInputBorder(),
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
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.noPasswordSpecified;
                    }
                    if (!value.contains(RegExp(r"[0-9]"))) {
                      return AppLocalizations.of(context)!
                          .passwordMustContainNumber;
                    }
                    if (value.length < 8) {
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
                  child: Text(AppLocalizations.of(context)!.register),
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
    final auth = Provider.of<AuthModel>(context);
    return Scaffold(
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(height: 0),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.lock),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                  child: Text(AppLocalizations.of(context)!.dataDisclaimer),
                ),
              ),
            ],
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.register),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: currentStep == steps(auth).length - 1
            ? null
            : () {
                final canGoToStep2 = currentStep == 0
                    ? _substitutionPlanPasswordFormKey.currentState!.validate()
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
        steps: steps(auth),
      ),
    );
  }
}
