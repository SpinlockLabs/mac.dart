import "package:osx/osx.dart";

main() async {
  print(await Geolocation.getLocation());
}
