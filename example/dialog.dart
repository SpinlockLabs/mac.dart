import "package:mac/mac.dart";

main() async {
  var result = await UI.displayDialog("Hello World", buttons: [
    "Ok",
    "Not Ok"
  ]);

  if (result.button == "Ok") {
    say("You said Ok.");
  } else {
    say("You didn't say Ok.");
  }
}
