import 'package:engelsburg_app/src/models/engelsburg_api/auth_info_dto.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/sign_up_request_dto.dart';
import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:flutter/material.dart';
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
          title: const Text('Passwort für den Vertretungsplan'),
          subtitle: const Text(
              'Wir müssen bestätigen, dass du auf die Engelsburg gehst!'),
          content: Form(
            key: _substitutionPlanPasswordFormKey,
            child: TextFormField(
              validator: (input) => input == null || input.isEmpty
                  ? 'Das Feld darf nicht leer sein'
                  : null,
              controller: _schoolTokenTextController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Passwort für den Vertretungsplan',
              ),
            ),
          )),
      Step(
        title: const Text('Email und Passwort'),
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
                  controller: _passwordTextController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscured,
                  onChanged: (text) {
                    if (_obscured == false) setState(() => _obscured = true);
                  },
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Passwort',
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
                    (await ApiService.signUp(SignUpRequestDTO(
                            schoolToken: _schoolTokenTextController.text,
                            email: _emailTextController.text,
                            password: _passwordTextController.text)))
                        .handle<AuthInfoDTO>(context,
                            parse: (json) => AuthInfoDTO.fromJson(json),
                            onSuccess: (auth) {
                              if (auth!.validate) {
                                authProvider.setTokenPair(
                                    //Not updating widget tree
                                    accessToken: auth.token!,
                                    refreshToken: auth.refreshToken!);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Erfolgreich angemeldet!')));
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Unerwarteter Fehler. Bitte versuche es später erneut!')));
                              }
                            },
                            onError: (error) {
                              if (error.isForbidden &&
                                  error.extra == 'school_token') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Falsches Passwort für den Vertretungsplan!')));
                                setState(() => currentStep = 0);
                              } else if (error.status == 400 &&
                                  error.messageKey == 'INVALID_PARAM') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Bitte gib eine richtige Email an!')));
                              } else if (error.isAlreadyExisting) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Ein Account mit dieser Email existiert bereits!')));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Unerwarteter Fehler. Bitte versuche es später erneut!')));
                              }
                            });
                  },
                  child: const Text('Registrieren'),
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
            children: const [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.lock),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
                  child: Text(
                      'Deine Daten werden sicher auf unserem Server in Kassel gespeichert. Das Passwort wird so verschlüsselt, dass es von keinem gelesen werden kann.'),
                ),
              ),
            ],
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('Registrieren'),
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
