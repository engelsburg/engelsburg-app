import 'package:engelsburg_app/src/models/api/dto/substitute_dto.dart';
import 'package:engelsburg_app/src/models/api/substitutes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class SubstituteCard extends StatefulWidget {
  const SubstituteCard({Key? key, required this.substitute}) : super(key: key);

  final SubstituteDTO substitute;

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
              const TextSpan(text: ' ('),
              TextSpan(
                  text: widget.substitute.substituteTeacher == null ||
                          widget.substitute.substituteTeacher == '+'
                      ? ''
                      : widget.substitute.substituteTeacher),
              TextSpan(
                  text: widget.substitute.substituteTeacher != null &&
                          widget.substitute.substituteTeacher != '+' &&
                          widget.substitute.teacher == null
                      ? ')'
                      : ''),
              TextSpan(
                  text: widget.substitute.substituteTeacher != null &&
                          widget.substitute.substituteTeacher != '+' &&
                          widget.substitute.teacher != null &&
                          widget.substitute.substituteTeacher !=
                              widget.substitute.teacher
                      ? ' ' + AppLocalizations.of(context)!.insteadOf + ' '
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
                  text: widget.substitute.text == null ||
                          widget.substitute.text!.isEmpty
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

  final SubstituteDTO substitute;

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
            color: _getTileColor(widget.substitute.type),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    widget.substitute.type.name(context),
                    textScaleFactor: 2.5,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.topLeft,
                      child: ListView(
                        shrinkWrap: true,
                        children: _buildText(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildText() {
    return [
      if (widget.substitute.lesson != null) const SizedBox(height: 10),
      if (widget.substitute.lesson != null)
        Text(
          AppLocalizations.of(context)!.lesson +
              ': ' +
              widget.substitute.lesson!,
          textScaleFactor: 1.5,
        ),
      if (widget.substitute.className != null) const SizedBox(height: 10),
      if (widget.substitute.className != null)
        Text(
          AppLocalizations.of(context)!.class_ +
              ': ' +
              widget.substitute.className!,
          textScaleFactor: 1.5,
        ),
      if (widget.substitute.subject != null) const SizedBox(height: 10),
      if (widget.substitute.subject != null)
        Text(
          AppLocalizations.of(context)!.subject +
              ': ' +
              widget.substitute.subject!,
          textScaleFactor: 1.5,
        ),
      if (widget.substitute.substituteTeacher != null)
        const SizedBox(height: 10),
      if (widget.substitute.substituteTeacher != null)
        Text(
          AppLocalizations.of(context)!.substituteTeacher +
              ': ' +
              widget.substitute.substituteTeacher!,
          textScaleFactor: 1.5,
        ),
      if (widget.substitute.teacher != null) const SizedBox(height: 10),
      if (widget.substitute.teacher != null)
        RichText(
          textScaleFactor: 1.5,
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            text: AppLocalizations.of(context)!.teacher + ': ',
            children: [
              TextSpan(
                text: widget.substitute.teacher!,
                style: const TextStyle(decoration: TextDecoration.lineThrough),
              ),
            ],
          ),
        ),
      if (widget.substitute.room != null) const SizedBox(height: 10),
      if (widget.substitute.room != null)
        Text(
          AppLocalizations.of(context)!.room + ': ' + widget.substitute.room!,
          textScaleFactor: 1.5,
        ),
      if (widget.substitute.substituteOf != null) const SizedBox(height: 10),
      if (widget.substitute.substituteOf != null)
        Text(
          AppLocalizations.of(context)!.substituteOf +
              ': ' +
              widget.substitute.substituteOf!,
          textScaleFactor: 1.5,
        ),
      if (widget.substitute.text != null && widget.substitute.text!.isNotEmpty)
        const SizedBox(height: 10),
      if (widget.substitute.text != null && widget.substitute.text!.isNotEmpty)
        Text(
          AppLocalizations.of(context)!.furtherInformation +
              ': ' +
              widget.substitute.text!,
          textScaleFactor: 1.5,
        ),
    ];
  }
}

class SubstituteMessageCard extends StatefulWidget {
  const SubstituteMessageCard(
      {Key? key, required this.substituteMessage, required this.formatter})
      : super(key: key);

  final SubstituteMessage substituteMessage;
  final DateFormat formatter;

  @override
  _SubstituteMessageCardState createState() => _SubstituteMessageCardState();
}

class _SubstituteMessageCardState extends State<SubstituteMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color:
              Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.formatter.format(widget.substituteMessage.date!),
                  textScaleFactor: 2,
                ),
              ),
              const Divider(height: 10, thickness: 5),
              const SizedBox(height: 10),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  if (widget.substituteMessage.absenceTeachers != null)
                    TableRow(
                      children: [
                        Text(AppLocalizations.of(context)!.absenceTeachers),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child:
                              Text(widget.substituteMessage.absenceTeachers!),
                        ),
                      ],
                    ),
                  if (widget.substituteMessage.absenceClasses != null)
                    TableRow(
                      children: [
                        Text(AppLocalizations.of(context)!.absenceClasses),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(widget.substituteMessage.absenceClasses!),
                        ),
                      ],
                    ),
                  if (widget.substituteMessage.affectedClasses != null)
                    TableRow(
                      children: [
                        Text(AppLocalizations.of(context)!.affectedClasses),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child:
                              Text(widget.substituteMessage.affectedClasses!),
                        ),
                      ],
                    ),
                  if (widget.substituteMessage.affectedRooms != null)
                    TableRow(
                      children: [
                        Text(AppLocalizations.of(context)!.affectedRooms),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(widget.substituteMessage.affectedRooms!),
                        ),
                      ],
                    ),
                  if (widget.substituteMessage.blockedRooms != null)
                    TableRow(
                      children: [
                        Text(AppLocalizations.of(context)!.blockedRooms),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(widget.substituteMessage.blockedRooms!),
                        ),
                      ],
                    ),
                  if (widget.substituteMessage.messages != null)
                    TableRow(
                      children: [
                        Text(AppLocalizations.of(context)!.news),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(widget.substituteMessage.messages!),
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
