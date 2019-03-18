import 'package:mac/mac.dart';

void main() {
  // TODO: Fix
  var volume = Volumes.getMainVolume();

  print('Volume Name: ${volume.name}');
  print('Volume ID: ${volume.id}');
  print('Volume Size: ${volume.sizeGigabytes} GB');
}
