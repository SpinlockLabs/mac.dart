import "package:mac/mac.dart";

void main() {
  print("Is Charging: ${Battery.isCharging()}");
  print("Plugged In: ${Battery.isPluggedIn()}");
  print("Level: ${Battery.getLevel()}%");
}
