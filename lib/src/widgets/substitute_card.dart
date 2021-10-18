import 'package:engelsburg_app/src/models/engelsburg_api/substitutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubstituteCard extends StatefulWidget {
  const SubstituteCard({Key? key, required this.substitute}) : super(key: key);

  final Substitute substitute;

  @override
  State<StatefulWidget> createState() => _SubstituteCardState();
}

class _SubstituteCardState extends State<SubstituteCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Text(widget.substitute.className!),
        color: Colors.green,
      ),
    );
  }
}

class SubstituteMessageCard extends StatefulWidget {
  const SubstituteMessageCard({Key? key, required this.substituteMessage})
      : super(key: key);

  final SubstituteMessage substituteMessage;

  @override
  _SubstituteMessageCardState createState() => _SubstituteMessageCardState();
}

class _SubstituteMessageCardState extends State<SubstituteMessageCard> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Text(widget.substituteMessage.messages!),
        color: Colors.green,
      ),
    );
  }
}
