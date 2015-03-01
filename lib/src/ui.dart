part of osx;

class UI {
  static DialogResult displayDialog(String text, {List<String> buttons, icon, String defaultAnswer, int giveUpAfter, defaultButton: 1}) {
    var script = 'display dialog "${text}"';

    script += _build({
      'default answer "#"': defaultAnswer,
      'with icon #': icon,
      'buttons #': buttons,
      'default button #': defaultButton,
      'giving up after #': giveUpAfter,
    });

    var result = runAppleScriptSync(script);
    var record = parseAppleScriptRecord(result);
    var r = new DialogResult();
    r.text = record["text returned"];
    r.button = record["button returned"];
    r.gaveUp = record["gave up"];
    return r;
  }

  static File chooseFile({String prompt, List<String> types, String defaultLocation, bool invisibles: false}) {
    var script = "POSIX path of (choose file";

    script += _build({
      'with prompt #': prompt,
      'of type #': types,
      'default location #': defaultLocation,
      'invisibles #': invisibles
    });

    script += ')';
    return new File(runAppleScriptSync(script));
  }

  static Directory chooseFolder({String prompt, String defaultLocation, bool invisibles: false}) {
    var script = "POSIX path of (choose folder";

    script += _build({
      'with prompt #': prompt,
      'default location #': defaultLocation,
      'invisibles #': invisibles
    });

    script += ')';
    return new Directory(runAppleScriptSync(script));
  }

  static Application chooseApplication({String title, String prompt}) {
    var script = "name of (choose application";

    script += _build({
      'with title "${title}"': title,
      'with prompt "${prompt}"': prompt
    });

    script += ")";

    return new Application(runAppleScriptSync(script));
  }

  static String _build(Map<String, dynamic> input) {
    var s = "";

    for (var key in input.keys) {
      var value = input[key];

      if (value != null) {
        var v = value.toString();

        if (value is List) {
          v = "{" + value.map((it) {
            if (it is String) {
              return '"${it}"';
            } else {
              return it.toString();
            }
          }).join(", ") + "}";
        }

        s += " ${key.replaceAll("#", v)}";
      }
    }
    return s;
  }
}

class Notifications {
  static void display(String text, {String title, String subtitle, String sound}) {
    var script = 'display notification "${text}"';

    script += UI._build({
      'with title "#"': title,
      "subtitle #": subtitle,
      'sound name "#"': sound
    });

    runAppleScriptSync(script);
  }
}

class DialogResult {
  String text;
  String button;
  bool gaveUp;
}
