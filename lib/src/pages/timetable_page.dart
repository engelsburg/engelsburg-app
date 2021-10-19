import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:engelsburg_app/src/widgets/locked_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  @override
  Widget build(BuildContext context) {
    AuthModel auth = Provider.of<AuthModel>(context);
    if (!auth.isLoggedIn) return const LockedScreen();

    return const Scaffold();
  }
}
