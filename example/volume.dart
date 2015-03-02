import "package:osx/osx.dart";

void main() {
  print("Volume Level: ${AudioVolume.getVolume()}");
  AudioVolume.mute();
  print("Is Muted: ${AudioVolume.isMuted()}");
  AudioVolume.unmute();
  AudioVolume.setVolume(AudioVolume.getVolume() + 1);
}
