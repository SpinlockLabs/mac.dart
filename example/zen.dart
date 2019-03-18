import 'package:mac/mac.dart';
import 'package:mac/utils.dart';

main() async {
  var text = await fetch('https://api.github.com/zen');
  say(text.trim());
}
