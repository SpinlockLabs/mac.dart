import "package:osx/osx.dart";

void main() {
  print("Is Charging: ${Battery.isCharging()}");
  print("Plugged In: ${Battery.isPluggedIn()}");
  print("Level: ${Battery.getLevel()}%");
}
