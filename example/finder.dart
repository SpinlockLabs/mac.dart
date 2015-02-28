import "package:osx/osx.dart";

void main() {
  var window = Finder.open("/");
  sleep(new Duration(milliseconds: 5000));
  window.close();
}
