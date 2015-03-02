import "package:osx/osx.dart";

void main() {
  GoogleChrome.activate();
  sleep(THREE_SECONDS);
  var tab = GoogleChrome.createTab(1);
  sleep(THREE_SECONDS);
  var name = tab.getName();
  print(name);
}
