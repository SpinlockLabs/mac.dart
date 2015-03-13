import "package:osx/osx.dart";

void main() {
  var result = UI.displayDialogSync("Hello World", buttons: [
    "Ok",
    "Not Ok"
  ]);

  if (result.button == "Ok") {
    say("You said Ok.");
  } else {
    say("You didn't say Ok.");
  }
}
