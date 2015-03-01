import "package:osx/osx.dart";

void main() {
  var file = UI.chooseFile();

  print(file.path);
}
