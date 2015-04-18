import "dart:io";
import "dart:convert";
import "package:osx/osx.dart";
import "package:osx/utils.dart";

class Data {
  static Map<String, String> storage = {};

  static String get(String key, [String defaultValue]) {
    load();
    return storage.containsKey(key) ? storage[key] : defaultValue;
  }

  static void set(String key, String value) {
    storage[key] = value;
    save();
  }

  static void load() {
    var file = new File("${Platform.environment["HOME"]}/.osx/commander.json");

    if (file.existsSync()) {
      storage = JSON.decode(file.readAsStringSync());
    }
  }

  static void save() {
    var file = new File("${Platform.environment["HOME"]}/.osx/commander.json");

    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    file.writeAsStringSync(new JsonEncoder.withIndent("  ").convert(storage));
  }
}

void main() {
  select();
}

void select() {
  var action = SpeechRecognizer.selectSync([
    "Open Application",
    "Go to Sleep",
    "Battery Level",
    "Repeat That",
    "What is my name?",
    "What do you call me?",
    "Change my name",
    "Open Chrome",
    "Open Mission Control",
    "Open Launchpad",
    "What time is it?",
    "Close Everything",
    "What version of OSX do I have?",
    "What is my computer named?"
  ], prompt: "What would you like?");

  if (action == "Open Application") {
    open();
  } else if (action == "Open Chrome") {
    GoogleChrome.activate();
  } else if (action == "Open Mission Control") {
    MissionControl.activate();
  } else if (action == "Open Launchpad") {
    Launchpad.activate();
  } else if (action == "What time is it?") {
    say("It is ${friendlyTime(now())}");
  } else if (action == "Go to Sleep") {
    Computer.sleep();
  } else if (action == "Close Everything") {
    closeEverything();
  } else if (action == "What is my computer named?") {
    say("Your computer is named ${SystemInformation.getComputerName()}");
  } else if (action == "What version of OSX do I have?") {
    say("You have Mac OSX v${SystemInformation.getVersion()}");
  } else if (action == "Battery Level") {
    say("Your battery is at ${Battery.getLevel()}%");
  } else if (action == "Repeat That") {
    select();
  } else if (action == "Open Slack") {
    Applications.activate("Slack");
  } else if (action == "What is my name?" || action == "What do you call me?") {
    var name = Data.get("name", "The User");

    say("${action == "What do you call me?" ? "I call you" : "Your name is"} ${name}.");
  } else if (action == "Change my name") {
    var name = Data.get("name", "The User");
    try {
      var result = UI.displayDialogSync("Enter Name", buttons: ["Ok"], defaultAnswer: name);
      if (!result.gaveUp) {
        Data.set("name", result.text);
        say("I will now call you ${result.text}");
      } else {
        say("You didn't enter anything, so I gave up.");
      }
    } catch (e) {
    }
  } else {
    say("I don't understand.");
    select();
  }
}

void closeEverything() {
  var result = SpeechRecognizer.selectSync([
    "Yes",
    "No",
    "Go Back"
  ], prompt: "Are you sure?");

  if (result == "Yes") {
    for (var app in TaskManager.getOpenTasks()) {
      Applications.quit(app);
    }
  } else if (result == "Go Back") {
  }
}

void open() {
  var apps = Applications.list().map((it) => it.name).toList();
  var result = SpeechRecognizer.selectSync([
    "What can I open?",
    "Go Back"
  ]..addAll(apps), prompt: "What would you like to open?");

  if (result == "What can I open?") {
    var str = apps.sublist(0, apps.length - 1).join(", ");
    str += ", and ${apps.last}";
    say(str);
    open();
  } else if (result == "Go Back") {
    select();
  } else {
    Applications.get(result).launch();
  }
}
