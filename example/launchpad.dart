import "package:mac/mac.dart";

void main() {
  Launchpad.activate();
  sleep(new Duration(seconds: 1));
  Launchpad.close();
}
