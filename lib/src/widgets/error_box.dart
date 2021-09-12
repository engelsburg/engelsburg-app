import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorBox extends StatelessWidget {
  final String? text;

  const ErrorBox({this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(64, 255, 125, 125),
            border: Border.all(color: const Color.fromARGB(125, 255, 0, 0)),
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(AppLocalizations.of(context)!.error.toUpperCase() + ':',
                  textScaleFactor: 1.3),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(text ??
                    AppLocalizations.of(context)!.unexpectedErrorMessage),
              )
            ],
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}
