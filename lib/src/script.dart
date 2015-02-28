part of osx;

Future<ProcessResult> runAppleScript(String input) async {
  return await Process.run("osascript", ["-e", input]);
}

String runAppleScriptSync(String input) {
  var result = Process.runSync("osascript", ["-e", input]);
  if (result.exitCode != 0) {
    throw new Exception("Failed to execute script!\nSTDERR:\n${result.stderr}");
  }
  return result.stdout.trim();
}

Future<ProcessResult> runOSAScript(String input, String language) async {
  return await Process.run("osascript", ["-l", language, "-e", input]);
}

void say(String text) {
  runAppleScriptSync('say "${text}"');
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
