import "package:osx/osx.dart";

void main() {
  var apps = Applications.list();

  for (var app in apps) {
    print(app.name);
  }
}
