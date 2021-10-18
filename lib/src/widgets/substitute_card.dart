import 'package:engelsburg_app/src/models/engelsburg_api/substitutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Container(
        height: 75,
        alignment: Alignment.center,
        child: Align(
          alignment: Alignment.topCenter,
          child: ListTile(
            onTap: () => showDialog(
              context: context,
              builder: (context) => ExtendedSubstituteCard(
                substitute: widget.substitute,
              ),
            ),
            leading: Align(
              child: Text(
                widget.substitute.lesson!,
                textScaleFactor: 1.8,
              ),
              alignment: Alignment.center,
              widthFactor: 1,
            ),
            title: Text(
              widget.substitute.type.name(context),
              textScaleFactor: 1.25,
            ),
            subtitle: _buildText(),
          ),
        ),
        color: _getTileColor(widget.substitute.type),
      ),
    );
  }

  Widget _buildText() {
    return Wrap(
      children: [
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style.copyWith(
                color: DefaultTextStyle.of(context)
                    .style
                    .color!
                    .withOpacity(0.75)),
            text: widget.substitute.className,
            children: [
              TextSpan(text: widget.substitute.className == null ? '' : ' – '),
              TextSpan(text: widget.substitute.subject),
              TextSpan(
                  text: widget.substitute.substituteTeacher == null
                      ? ''
                      : ' (${widget.substitute.substituteTeacher}'),
              TextSpan(
                  text: widget.substitute.substituteTeacher != null &&
                          widget.substitute.teacher == null
                      ? ')'
                      : ''),
              TextSpan(
                  text: widget.substitute.substituteTeacher != null &&
                          widget.substitute.teacher != null &&
                          widget.substitute.substituteTeacher !=
                              widget.substitute.teacher
                      ? ' ' + AppLocalizations.of(context)!.insteadOf + ' '
                      : ''),
              TextSpan(
                  text: widget.substitute.substituteTeacher != null &&
                          widget.substitute.teacher == null
                      ? ' ('
                      : ''),
              TextSpan(
                  text: widget.substitute.teacher ==
                          widget.substitute.substituteTeacher
                      ? ''
                      : widget.substitute.teacher,
                  style:
                      const TextStyle(decoration: TextDecoration.lineThrough)),
              TextSpan(text: widget.substitute.teacher != null ? ')' : ''),
              TextSpan(
                  text: widget.substitute.room == null
                      ? ''
                      : ' in ' + widget.substitute.room!),
              TextSpan(
                  text: widget.substitute.text == null
                      ? ''
                      : ' – ${widget.substitute.text}'),
              TextSpan(
                  text: widget.substitute.substituteOf == null
                      ? ''
                      : ' – ${widget.substitute.substituteOf}')
            ],
          ),
        ),
      ],
    );
  }
}

Color _getTileColor(SubstituteType type) {
  switch (type) {
    case SubstituteType.canceled:
      return Colors.redAccent;
    case SubstituteType.independentWork:
      return Colors.purple;
    case SubstituteType.roomSubstitute:
      return Colors.lightBlueAccent;
    case SubstituteType.care:
      return Colors.green;
    default:
      return Colors.blueAccent;
  }
}

class ExtendedSubstituteCard extends StatefulWidget {
  const ExtendedSubstituteCard({Key? key, required this.substitute})
      : super(key: key);

  final Substitute substitute;

  @override
  _ExtendedSubstituteCardState createState() => _ExtendedSubstituteCardState();
}

class _ExtendedSubstituteCardState extends State<ExtendedSubstituteCard> {
  @override
  Widget build(BuildContext context) {
    double height = (MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.width) *
            0.5,
        width = (MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height
                : MediaQuery.of(context).size.width) *
            0.5;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      insetPadding: const EdgeInsets.all(10),
      child: SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: _getTileColor(widget.substitute.type).withOpacity(0.9),
            child: Padding(
              child: ListView(
                children: [
                  Text(
                    widget.substitute.type.name(context),
                    textScaleFactor: 2.5,
                  ),
                  const Divider(height: 10, thickness: 0),
                  if (widget.substitute.lesson != null)
                    Text(
                      AppLocalizations.of(context)!.lesson +
                          ': ' +
                          widget.substitute.lesson!,
                      textScaleFactor: 1.5,
                    ),
                  const SizedBox(height: 10),
                  if (widget.substitute.className != null)
                    Text(
                      AppLocalizations.of(context)!.class_ +
                          ': ' +
                          widget.substitute.className!,
                      textScaleFactor: 1.5,
                    ),
                  const SizedBox(height: 10),
                  if (widget.substitute.subject != null)
                    Text(
                      AppLocalizations.of(context)!.subject +
                          ': ' +
                          widget.substitute.subject!,
                      textScaleFactor: 1.5,
                    ),
                  const SizedBox(height: 10),
                  if (widget.substitute.substituteTeacher != null)
                    Text(
                      AppLocalizations.of(context)!.substituteTeacher +
                          ': ' +
                          widget.substitute.substituteTeacher!,
                      textScaleFactor: 1.5,
                    ),
                  const SizedBox(height: 10),
                  if (widget.substitute.teacher != null)
                    RichText(
                      textScaleFactor: 1.5,
                      text: TextSpan(
                        text: AppLocalizations.of(context)!.teacher + ': ',
                        children: [
                          TextSpan(
                            text: widget.substitute.teacher!,
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 10),
                  if (widget.substitute.room != null)
                    Text(
                      AppLocalizations.of(context)!.room +
                          ': ' +
                          widget.substitute.room!,
                      textScaleFactor: 1.5,
                    ),
                  const SizedBox(height: 10),
                  if (widget.substitute.substituteOf != null)
                    Text(
                      AppLocalizations.of(context)!.substituteOf +
                          ': ' +
                          widget.substitute.substituteOf!,
                      textScaleFactor: 1.5,
                    ),
                  const SizedBox(height: 10),
                  if (widget.substitute.text != null)
                    Text(
                      AppLocalizations.of(context)!.furtherInformation +
                          ': ' +
                          widget.substitute.text!,
                      textScaleFactor: 1.5,
                    ),
                ],
              ),
              padding: const EdgeInsets.all(20),
            ),
          ),
        ),
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
