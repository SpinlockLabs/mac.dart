import "package:osx/osx.dart";

void main() {
  say("Battery is at ${Battery.getLevel()}%");
  say("There are ${Applications.list().length} apps installed");
}
