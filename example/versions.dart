import "package:mac/mac.dart";

void main() {
  print("macOS Version: ${SystemInformation.getVersion()}");
  print("Google Chrome: ${Applications.getVersion("Google Chrome")}");
}
