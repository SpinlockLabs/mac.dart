import "package:osx/osx.dart";

void main() {
  MissionControl.activate(slow: true);
  sleep(FIVE_SECONDS);
  MissionControl.close(slow: true);
}
