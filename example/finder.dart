import "package:osx/osx.dart";

void main() {
  var window = Finder.open("/");
  sleep(FIVE_SECONDS);
  window.close();
}
