/// Example of Interacting with other Application UI

import 'package:mac/mac.dart';

void main() {
  Applications.makeFrontMost('Google Chrome');
  sleep(ONE_SECOND);
  // TODO: Fix
  Applications.tellUI('Google Chrome', '''
  click menu item "New Tab" of menu "File" of menu bar 1
  ''');
}
