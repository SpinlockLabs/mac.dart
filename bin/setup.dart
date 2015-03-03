import "dart:io";

File executableBuild = new File(new File(Platform.script.toFilePath()).parent.parent.path + "/helper/build/Release/helper");
File executableGlobal = new File("${Platform.environment["HOME"]}/Library/Dart/OSX/helper");


main(List<String> args) async {
  if (args.contains("--build") || args.contains("-b") || args.contains("-f")) {
    await build();
  }

  install();
}

void install() {
  print("Installing OSX Helper");

  if (!executableGlobal.parent.existsSync()) {
    executableGlobal.parent.createSync(recursive: true);
  }

  executableGlobal.writeAsBytesSync(executableBuild.readAsBytesSync());

  var result = Process.runSync("chmod", ["+x", executableBuild.path]);

  if (result.exitCode != 0) {
    print("Failed to make ${executableGlobal.path} executable!");
    exit(1);
  }

  print("OSX Helper has been installed.");
}

build() async {
  print("Building OSX Helper");

  var process = await Process.start("xcodebuild", [], workingDirectory: executableBuild.parent.parent.parent.path);
  var a = process.stdout.listen((data) => stdout.add(data));
  var b = process.stderr.listen((data) => stderr.add(data));

  var exitCode = await process.exitCode;

  for (var m in [a, b]) {
    m.cancel();
  }

  if (exitCode != 0) {
    print("Build Failed.");
    exit(1);
  }
}
