library osx.helper;

import "dart:convert";
import "dart:io";

class Helper {
  static File executable = init();

  static File init() {
    var scriptUri = Platform.script;
    var scriptPath = scriptUri.toFilePath();
    var scriptFile = new File(scriptPath);
    var dir = scriptFile.parent;
    var pkgDir = new Directory("${dir.path}/packages");
    if (Platform.packageRoot != null && Platform.packageRoot.isNotEmpty) {
      pkgDir = new Directory(Platform.packageRoot);
    }

    var exe = new File("${pkgDir.path}/osx/compiled/helper");

    if (!exe.existsSync()) {
      throw new Exception("Unable to initialize helper. Failed to find compiled helper.");
    }

    return exe;
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

  static bool activate(String application) => send({
    "type": "activate",
    "app": application
  })["success"];

  static bool quit(String application) => send({
    "type": "quit",
    "app": application
  })["success"];
}
