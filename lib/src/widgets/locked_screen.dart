import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LockedScreen extends StatefulWidget {
  const LockedScreen({Key? key}) : super(key: key);

  @override
  State<LockedScreen> createState() => _LockedScreenState();
}

class _LockedScreenState extends State<LockedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation animation;

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween(begin: 0.0, end: 24.0)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 200,
            child: Text(
              AppLocalizations.of(context)!.needToLoggedInError,
              textAlign: TextAlign.center,
              textScaleFactor: 1.3,
              softWrap: true,
            ),
          ),
          Container(height: 20),
          AnimatedBuilder(
            animation: animation,
            builder: (context, widget) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                padding: EdgeInsets.only(
                    left: animation.value + 24.0,
                    right: 24.0 - animation.value),
                child: const Center(
                  child: Icon(
                    Icons.lock_outline_rounded,
                    size: 100,
                    color: Colors.redAccent,
                  ),
                ),
              );
            },
          ),
          Container(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, "/register"),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(const Size(200, 40)),
            ),
            child: Center(
              child: Text(AppLocalizations.of(context)!.register),
            ),
          ),
        ],
      ),
      onTap: () => controller.forward(),
    );
  }
}
