import "package:mac/mac.dart";

void main() {
  MissionControl.activate();
  sleep(THREE_SECONDS);
  MissionControl.close();
}
