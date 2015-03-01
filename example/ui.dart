/// Example of Interacting with other Application UI

import "package:osx/osx.dart";

void main() {
  Applications.makeFrontMost("Google Chrome");
  sleep(ONE_SECOND);
  Applications.tellUI("Google Chrome", """
  click menu item "New Tab" of menu "File" of menu bar 1
  """);
}
