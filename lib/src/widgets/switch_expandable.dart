import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchListExpandable extends StatefulWidget {
  final SwitchListTile switchListTile;
  final Widget child;

  ///AnimatedSize settings
  final Alignment alignment;
  final Curve curve;
  final Duration duration;
  final Duration? reverseDuration;
  final TickerProvider vsync;
  final Clip clipBehavior;

  const SwitchListExpandable({
    Key? key,
    required this.switchListTile,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOut,
    required this.vsync,
    this.alignment = Alignment.center,
    this.clipBehavior = Clip.hardEdge,
    this.reverseDuration,
  }) : super(key: key);

  @override
  _SwitchListExpandableState createState() => _SwitchListExpandableState();
}

class _SwitchListExpandableState extends State<SwitchListExpandable> {
  @override
  Widget build(BuildContext context) {
    double? height = !widget.switchListTile.value ? 0 : null;

    return Container(
      child: Column(
        children: [
          widget.switchListTile,
          AnimatedSize(
            child: Container(
              height: height,
              child: widget.child,
            ),
            duration: widget.duration,
            curve: widget.curve,
            vsync: widget.vsync,
            alignment: widget.alignment,
            clipBehavior: widget.clipBehavior,
            reverseDuration: widget.reverseDuration,
          ),
        ],
      ),
    );
  }
}
