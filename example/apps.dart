import 'package:mac/mac.dart';

void main() {
  _checkIfInstalled("Google Chrome");
  _checkIfInstalled("Slack");
}

void _checkIfInstalled(String appName) {
  var app = Applications.get(appName);

  if (app.isInstalled()) {
    print('IDs: ${app.getIds()}');
    print('Path: ${app.getPath()}');
  } else {
    print('$appName is not installed.');
  }
}
