import "package:osx/osx.dart";

void main() {
  MissionControl.activate(slow: true);
  sleep(THREE_SECONDS);
  MissionControl.close(slow: true);
}
