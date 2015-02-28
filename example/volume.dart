import "package:osx/osx.dart";

void main() {
  print("Volume Level: ${Volume.getVolume()}");
  Volume.mute();
  print("Is Muted: ${Volume.isMuted()}");
  Volume.unmute();
  Volume.setVolume(Volume.getVolume() + 1);
}
