import "package:osx/osx.dart";

void main() {
  ask();
}

void ask() {
  var result = SpeechRecognizer.select([
    "Mission Control",
    "Google Chrome",
    "Textual 5",
    "What can I open?"
  ], prompt: "What would you like to open?");

  if (result == "What can I open?") {
    say("Mission Control, Google Chrome, and Textual 5");
    ask();
  } else if (result == "Mission Control") {
    MissionControl.activate();
  } else {
    Applications.get(result).launch();
  }
}
