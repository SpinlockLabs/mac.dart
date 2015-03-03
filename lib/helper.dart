library osx.helper;

import "dart:convert";
import "dart:io";

class Helper {
  static File executable = new File("${Platform.environment["HOME"]}/Library/Dart/OSX/helper");

  static void init() {
    if (!executable.existsSync()) {
      throw new Exception("Unable to initialize helper. Please run bin/setup.dart in the OSX.dart repository to install it.");
    }
  }

  static dynamic send(Map<String, dynamic> input) {
    var result = Process.runSync(executable.path, ["-command", JSON.encode(input)]);

    if (result.exitCode != 0) {
      throw new Exception("Failed to execute helper.");
    }

    return JSON.decode(result.stdout.trim());
  }

  static Map<String, dynamic> getSystemInformation() => send({
    "type": "sysinfo"
  });

  static List<String> getInstalledApplications() => send({
    "type": "applications"
  });
}
