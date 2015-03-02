import "package:osx/osx.dart";

void main() {
  select();
}

void select() {
  var action = SpeechRecognizer.select([
    "Open Application",
    "Go to Sleep",
    "Battery Level"
  ], prompt: "What do you want?");

  if (action == "Open Application") {
    open();
  } else if (action == "Go to Sleep") {
    Computer.sleep();
  } else if (action == "Battery Level") {
    say("Your battery is at ${Battery.getLevel()}%");
  } else {
    say("I don't understand.");
    select();
  }
}

void open() {
  var apps = Applications.list().map((it) => it.name).toList();
  var result = SpeechRecognizer.select([
    "What can I open?"
  ]..addAll(apps), prompt: "What would you like to open?");

  if (result == "What can I open?") {
    var str = apps.sublist(0, apps.length - 1).join(", ");
    str += ", and ${apps.last}";
    say(str);
    open();
  } else {
    Applications.get(result).launch();
  }
}
