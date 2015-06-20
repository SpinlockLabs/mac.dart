import "package:osx/osx.dart";

main() {
  var l = SystemProfiler.read("SPHardwareDataType");
  pr(l);
}

void pr(ProfilerData data, {String indent: ""}) {
  print("${indent}${data.name}:");

  if (!data.hasChildren) {
    for (var lm in data.metrics.keys) {
      print("${indent}  ${lm}: ${data.metrics[lm]}");
    }
  } else {
    data.children.forEach((x) => pr(x, indent: indent + "  "));
  }
}
