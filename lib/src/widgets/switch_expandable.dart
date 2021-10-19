import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchExpandable extends StatefulWidget {
  final SwitchListTile switchListTile;
  final Widget child;
  final bool invert;

  ///Animation settings
  final Curve curve;
  final Duration duration;
  final Duration? reverseDuration;

  const SwitchExpandable({
    Key? key,
    required this.switchListTile,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.reverseDuration,
    this.invert = false,
  }) : super(key: key);

  @override
  _SwitchExpandableState createState() => _SwitchExpandableState();
}

class _SwitchExpandableState extends State<SwitchExpandable>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
    );
    animation = CurvedAnimation(parent: controller, curve: widget.curve)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    !widget.switchListTile.value ^ widget.invert
        ? controller.reverse()
        : controller.forward();

    return Column(
      children: [
        widget.switchListTile,
        SizeTransition(
          child: widget.child,
          sizeFactor: animation,
        ),
      ],
    );
  }
}
