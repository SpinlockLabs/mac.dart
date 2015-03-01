import "package:osx/osx.dart";

void main() {
  print("Mac OSX Version: ${SystemInformation.getVersion()}");
  print("Computer Name: ${SystemInformation.getComputerName()}");
  print("Hostname: ${SystemInformation.getHostName()}");
}
