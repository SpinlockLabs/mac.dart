import "package:mac/mac.dart";

main() async {
  print(await Geolocation.getLocation());
}
