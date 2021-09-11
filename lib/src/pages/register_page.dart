import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static final _substitutionPlanPasswordFormKey = GlobalKey<FormState>();
  static final _emailAndPasswordFormKey = GlobalKey<FormState>();
  var currentStep = 0;

  final steps = [
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
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
                prefixIcon: Icon(Icons.mail),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Passwort',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ),
            Container(
              height: 64.0,
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Registrieren'),
              ),
            )
          ],
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
        onStepContinue: currentStep == steps.length - 1
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
        steps: steps,
      ),
    );
  }
}
