import "package:osx/osx.dart";

void main() {
  var content = Clipboard.get();
  print(content);
}
