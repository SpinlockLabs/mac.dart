import "package:mac/mac.dart";

void main() {
  var app = Applications.get("Textual 5");

  if (app.isInstalled()) {
    print("IDs: ${app.getIds()}");
    print("Path: ${app.getPath()}");
  }
}
