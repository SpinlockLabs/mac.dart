import "package:osx/osx.dart";

void main() {
  var file = UI.chooseFileSync();

  print(file.path);
}
