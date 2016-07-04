import "package:mac/mac.dart";

main() async {
  var domains = Defaults.listDomains();

  for (var domain in domains) {
    print("- ${domain}");
  }
}
