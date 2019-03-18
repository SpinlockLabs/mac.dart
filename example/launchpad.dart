import 'dart:async';

import 'package:mac/mac.dart';

main() async {
  Launchpad.activate();
  await Future.delayed(const Duration(seconds: 3));
  // TODO: Fix
  Launchpad.close();
}
