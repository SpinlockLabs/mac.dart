import "package:osx/osx.dart";

main() async {
  var domains = await Defaults.listDomains();

  for (var domain in domains) {
    print("- ${domain}");
  }
}
