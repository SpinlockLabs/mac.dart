import 'package:mac/mac.dart';

main() async {
  var info = Applications.getInfoPlist("Google Chrome");
  print(info);
}
