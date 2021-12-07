import 'package:flutter/cupertino.dart';

class GlobalContext {
  static final key = GlobalKey<NavigatorState>();

  static BuildContext get get {
    return key.currentContext!;
  }
}
