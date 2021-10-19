import 'package:engelsburg_app/src/provider/auth.dart';
import 'package:engelsburg_app/src/widgets/locked_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    AuthModel auth = Provider.of<AuthModel>(context);
    if (!auth.isLoggedIn) return const LockedScreen();

    return Scaffold();
  }
}
