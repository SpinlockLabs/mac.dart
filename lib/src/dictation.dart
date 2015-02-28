part of osx;

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
