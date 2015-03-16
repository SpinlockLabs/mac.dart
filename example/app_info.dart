import "package:osx/osx.dart";

main() async {
  var info = Applications.getInfoPlist("Google Chrome Canary");
  print(info);
}
