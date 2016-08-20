import "package:mac/mac.dart";
import "dart:async";

main() async {
  Launchpad.activate();
  await new Future.delayed(const Duration(seconds: 3));
  Launchpad.close();
}
