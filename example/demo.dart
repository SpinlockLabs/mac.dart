import "package:osx/osx.dart";

List<String> features = [
  "User Interface Elements",
  "Notification APIs",
  "Text to Speech",
  "Speech Recognition",
  "System Information",
  "Volume Controls",
  "Battery Information",
  "Finder Interaction",
  "Application Interaction",
  "Keyboard Input Simulation",
  "Sleep and Wake"
];

void main() {
  say("Dart + OSX = Win");
  say("Here are my features:");
  features.forEach(say);
}
