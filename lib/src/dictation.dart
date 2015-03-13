part of osx;

class SpeechRecognizer {
  static String selectSync(List<String> commands, {String prompt}) {
    var script = "listen";
    script += UI._build({
      "for #": commands,
      'with prompt "#"': prompt
    });

    return parseAppleScriptRecord(Applications.tellSync("SpeechRecognitionServer", script));
  }

  static Future<String> select(List<String> commands, {String prompt}) async {
    var script = "listen";

    script += UI._build({
      "for #": commands,
      'with prompt "#"': prompt
    });

    return parseAppleScriptRecord(await Applications.tell("SpeechRecognitionServer", script));
  }
}

speak(input, {String voice}) async {
  if (input == null) {
    return false;
  }

  if (input is List<String>) {
    input = input.join("\n");
  } else if (input is File) {
    input = await input.readAsString();
  } else if (input is! String) {
    input = input.toString();
  }

  var lines = input.split("\n");

  for (var line in lines) {
    var args = [];

    if (voice != null) {
      args.addAll(["-v", voice]);
    }

    args.add(line);

    await Process.run("say", args);
  }
}
