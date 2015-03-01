import "package:osx/osx.dart";
import "package:osx/utils.dart";

main() async {
  var text = await getText("https://api.github.com/zen");
  say(text.trim());
}
