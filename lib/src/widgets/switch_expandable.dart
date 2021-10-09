import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchExpandable extends StatefulWidget {
  final SwitchListTile switchListTile;
  final Widget child;
  final bool invert;

  ///AnimatedSize settings
  final Alignment alignment;
  final Curve curve;
  final Duration duration;
  final Duration? reverseDuration;
  final Clip clipBehavior;

  const SwitchExpandable({
    Key? key,
    required this.switchListTile,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.decelerate,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.hardEdge,
    this.reverseDuration,
    this.invert = false,
  }) : super(key: key);

  @override
  _SwitchExpandableState createState() => _SwitchExpandableState();
}

class _SwitchExpandableState extends State<SwitchExpandable> {
  bool updated =
      true; //otherwise all cascaded switchExpandable animations get triggered

  @override
  Widget build(BuildContext context) {
    double? height = !widget.switchListTile.value ^ widget.invert ? 0 : null;

    SizedBox box = SizedBox(
      height: height,
      child: widget.child,
    );

    return Column(
      children: [
        widget.switchListTile,
        updated
            ? AnimatedSize(
                child: box,
                duration: widget.duration,
                curve: widget.curve,
                alignment: widget.alignment,
                clipBehavior: widget.clipBehavior,
                reverseDuration: widget.reverseDuration ?? widget.duration,
              )
            : box,
      ],
    );
  }

  @override
  void didUpdateWidget(SwitchExpandable oldWidget) {
    super.didUpdateWidget(oldWidget);
    updated = oldWidget.switchListTile.value != widget.switchListTile.value;
  }
}
