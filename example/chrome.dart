import "package:osx/osx.dart";

void main() {
  var window = GoogleChrome.getMainWindow();
  print(window.id);
  window.focus();
  window.getActiveTab().goto("http://www.google.com");
}
