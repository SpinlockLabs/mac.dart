import "package:osx/osx.dart";

void main() {
  ask();
}

void ask() {
  var apps = Applications.list().map((it) => it.name).toList();
  var result = SpeechRecognizer.select([
    "What can I open?"
  ]..addAll(apps), prompt: "What would you like to open?");

  if (result == "What can I open?") {
    var str = apps.sublist(0, apps.length - 1).join(", ");
    str += ", and ${apps.last}";
    say(str);
    ask();
  } else if (result == "Mission Control") {
    MissionControl.activate();
  } else {
    Applications.get(result).launch();
  }
}
