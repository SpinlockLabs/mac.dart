import "package:osx/osx.dart";

void main() {
  say("Your computer is named: ${SystemInformation.getComputerName()}");
  say("You are running OSX ${SystemInformation.getVersion()}");
  say("Battery is at ${Battery.getLevel()}%");
  say("There are ${Applications.list().length} apps installed");
}
