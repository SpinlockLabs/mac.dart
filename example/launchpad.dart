import "package:osx/osx.dart";

void main() {
  Launchpad.activate();
  sleep(new Duration(seconds: 1));
  Launchpad.close();
}
