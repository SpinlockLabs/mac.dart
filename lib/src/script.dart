part of osx;

Future<ProcessResult> runAppleScript(String input) async {
  return await Process.run("osascript", ["-e", input]);
}

String runAppleScriptSync(String input) {
  var result = Process.runSync("osascript", ["-e", input]);
  if (result.exitCode != 0) {
    String error = result.stderr.trim();

    if (error.contains("User canceled")) {
      throw new UserCanceledException();
    }

    if (error.contains("syntax error:")) {
      var split = error.split(":");
      var msg = split.skip(2).join(":").trim();
      throw new ScriptSyntaxError(msg);
    }

    throw new Exception("Failed to execute script!\nSTDERR:\n${error}");
  }
  return result.stdout.trim();
}

class ScriptSyntaxError {
  final String message;

  ScriptSyntaxError(this.message);

  @override
  String toString() => "${message}";
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

String tellApplicationSync(String app, String action){
  return runAppleScriptSync("""
  tell application "${app}"
    ${action}
  end tell
  """);
}

dynamic parseAppleScriptRecord(String input) {
  return new RecordParser().parse(input).value;
}
