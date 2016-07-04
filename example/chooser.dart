import "package:mac/mac.dart";

void main() {
  var file = UI.chooseFileSync();

  print(file.path);
}
