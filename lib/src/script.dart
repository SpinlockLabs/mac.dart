part of osx;

Future<ProcessResult> runAppleScript(String input) async {
  return await Process.run("osascript", ["-e", input]);
}

String runAppleScriptSync(String input) {
  var result = Process.runSync("osascript", ["-e", input]);
  if (result.exitCode != 0) {
    var error = result.stderr.trim();

    if (error.contains("User canceled")) {
      throw new UserCanceledException();
    }

    throw new Exception("Failed to execute script!\nSTDERR:\n${error}");
  }
  return result.stdout.trim();
}

class UserCanceledException {
  @override
  String toString() => "User Canceled the Operation";
}

Future<ProcessResult> runOSAScript(String input, String language) async {
  return await Process.run("osascript", ["-l", language, "-e", input]);
}

void say(String text, {String voice}) {
  runAppleScriptSync('say "${text}"${voice != null ? ' using "${voice}"' : ""}');
}

Future<ProcessResult> tellApplication(String app, String action) async {
  return (await runAppleScript("""
  tell application "${app}"
    ${action}
  end tell
  """));
}

Map<String, dynamic> parseAppleScriptRecord(String input) {
  try {
    if (input.startsWith("{") || input.startsWith("[")) {
      return lson.parse(input);
    } else {
      return parseAppleScriptRecord("{${input}}");
    }
  } catch (e) {
    // Probably a List
    try {
      var i = input.substring(1, input.length - 1);
      return parseAppleScriptRecord("[" + i + "]");
    } catch (e) {
      throw new FormatException();
    }
  }
}

String tellApplicationSync(String app, String action){
  return runAppleScriptSync("""
  tell application "${app}"
    ${action}
  end tell
  """);
}
