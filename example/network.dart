import "package:osx/osx.dart";

void main() {
  print("Network Name: ${Network.getNetworkName("en0")}");
  print("Signal Strength: ${Network.getSignalStrength()}");
}
