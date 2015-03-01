import "package:osx/osx.dart";

void main() {
  var result = SpeechRecognizer.select([
    "Good",
    "Bad"
  ], prompt: "How are you?");

  say("You said you are ${result}");
}
