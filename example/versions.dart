import "package:osx/osx.dart";

void main() {
  print("OSX Version: ${SystemInformation.getVersion()}");
  print("Google Chrome: ${Applications.getVersion("Google Chrome")}");
  print("Textual 5: ${Applications.getVersion("Textual 5")}");
  print("Cakebrew: ${Applications.getVersion("Cakebrew")}");
}
