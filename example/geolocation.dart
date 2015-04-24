import "package:osx/osx.dart";

void main() {
  print(await Geolocation.getLocation());
}
