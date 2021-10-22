import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:engelsburg_app/src/widgets/switch_expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

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
            onPressed: () => Navigator.pushNamed(context, "/signUp"),
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all<Size>(const Size(200, 40)),
            ),
            child: Center(
              child: Text(AppLocalizations.of(context)!.signUp),
            ),
          ),
        ],
      ),
      onTap: () => controller.forward(),
    );
  }
}

class Locked extends StatelessWidget {
  const Locked({Key? key, required this.child, this.enforceVerified = true})
      : super(key: key);

  final Widget child;
  final bool enforceVerified;

  @override
  Widget build(BuildContext context) {
    AuthModel auth = context.read<AuthModel>();
    final key = GlobalKey<State<Tooltip>>();

    if (!auth.isLoggedIn || (!auth.isVerified && enforceVerified)) {
      return Tooltip(
        key: key,
        message: !auth.isLoggedIn
            ? AppLocalizations.of(context)!.needToLoggedInError
            : AppLocalizations.of(context)!.needToVerifiedError,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onTap(key),
          child: Disabled(
            child: child,
          ),
        ),
      );
    }

    return child;
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
  }
}
