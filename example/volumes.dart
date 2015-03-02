import "package:osx/osx.dart";

void main() {
  var volume = Volumes.getMainVolume();

  print("Volume Name: ${volume.name}");
  print("Volume ID: ${volume.id}");
  print("Volume Size: ${volume.size}");
}
