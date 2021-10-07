import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchListTileExpandable extends StatefulWidget {
  final SwitchListTile switchListTile;
  final Widget child;

  ///AnimatedSize settings
  final Alignment alignment;
  final Curve curve;
  final Duration duration;
  final Duration? reverseDuration;
  final Clip clipBehavior;

  const SwitchListTileExpandable({
    Key? key,
    required this.switchListTile,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.hardEdge,
    this.reverseDuration,
  }) : super(key: key);

  @override
  _SwitchListTileExpandableState createState() =>
      _SwitchListTileExpandableState();
}

class _SwitchListTileExpandableState extends State<SwitchListTileExpandable> {
  @override
  Widget build(BuildContext context) {
    double? height = !widget.switchListTile.value ? 0 : null;

    return Column(
      children: [
        widget.switchListTile,
        Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          visible: height != 0,
          child: AnimatedSize(
            child: SizedBox(
              height: height,
              child: widget.child,
            ),
            duration: widget.duration,
            curve: widget.curve,
            alignment: widget.alignment,
            clipBehavior: widget.clipBehavior,
            reverseDuration: widget.reverseDuration,
          ),
        ),
      ],
    );
  }
}
