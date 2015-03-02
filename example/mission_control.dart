import "package:osx/osx.dart";

void main() {
  MissionControl.activate();
  sleep(THREE_SECONDS);
  MissionControl.close();
}
