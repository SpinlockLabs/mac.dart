part of osx;

class Finder {
  static void activate() {
    Applications.activate("Finder");
  }

  static FinderWindow open([String path]) {
    tell("make new Finder window");
    var window = getWindows().last;
    if (path != null) {
      window.goto(path);
    }
    window.activate();
    return window;
  }

  static String tell(String action) {
    return Applications.tell("Finder", action);
  }

  static FinderWindow getFrontWindow() {
    return new FinderWindow("front Finder window");
  }

  static void closeAll() {
    Applications.closeAll("Finder");
  }

  static List<FinderWindow> getWindows() {
    var count = getWindowCount();
    if (count == 0) {
      return [];
    }

    var windows = [];
    for (var i = 1; i <= count; i++) {
      windows.add(new FinderWindow(i));
    }
    return windows;
  }

  static int getWindowCount() => Applications.getWindowCount("Finder");

  static FinderWindow getWindow(dynamic id) => new FinderWindow(id);
}

class FinderWindow {
  dynamic id;

  FinderWindow(this.id);

  void goto(String path) {
    Finder.tell('set target of ${refId} to (POSIX file "${path}")');
  }

  void close() {
    Finder.tell("close ${refId}");
  }

  void moveForward() {
    setIndex(getIndex() + 1);
  }

  void moveBack() {
    setIndex(getIndex() - 1);
  }

  void moveToFront() {
    setIndex(1);
  }

  void moveToBack() {
    setIndex(Finder.getWindowCount() + 1);
  }

  void setIndex(int targetId) {
    Finder.tell("set index of ${refId} to ${targetId}");
    id = targetId;
  }

  int getIndex() {
    return int.parse(Finder.tell("index of ${refId}"));
  }

  void activate() {
    moveToFront();
    Finder.activate();
  }

  String get refId => id is int ? "Finder window ${id}" : id;
}

class TaskManager {
  static Set<String> getOpenTasks() {
    return runAppleScriptSync('''
    tell application "System Events" to get name of every process whose background only is false
    ''').split(", ").toSet();
  }

  static Set<String> getTasks() {
    return runAppleScriptSync('''
    tell application "System Events" to get name of every process
    ''').split(", ").toSet();
  }

  static Set<String> getVisibleTasks() {
    return runAppleScriptSync('''
    tell application "System Events" to get name of every process whose visible is true
    ''').split(", ").toSet();
  }
}

class Launchpad {
  static void activate() {
    Applications.activate("Launchpad");
  }

  static void close() {
    Applications.quit("Launchpad");
  }
}

class MissionControl {
  static void activate() {
    SystemEvents.key("code 126 using control down");
  }

  static void close() {
    Applications.quit("Mission Control");
  }
}

class Dashboard {
  static void activate() {
    SystemEvents.key("code 123 using control down");
  }

  static void close() {
    Applications.quit("Dashboard");
  }
}

class Applications {
  static void activate(String name) {
    tellApplicationSync(name, "activate");
  }

  static void quit(String name) {
    tellApplicationSync(name, "quit");
  }

  static int getWindowCount(String name) {
    return int.parse(tellApplicationSync(name, "count of Finder windows"));
  }

  static void closeAll(String name) {
    tell(name, "close every window");
  }

  static void reopen(String name) {
    tell(name, "reopen");
  }

  static Set<Application> list() {
    return runAppleScriptSync(r'''
    paragraphs of (do shell script "find /Applications/ -name \"*.app\" -maxdepth 2| sed -e \"s/\\(.*\\)\\/\\([^\\/]*\\).app/\\2/g\"")
    ''').split(", ").toSet().map((it) => new Application(it));
  }

  static String tell(String name, String action) => tellApplicationSync(name, action);
}

class SystemEvents {
  static String tell(String action) {
    return Applications.tell("System Events", action);
  }

  static void keystroke(String input) {
    tell('keystroke ${input}');
  }

  static void keyCode(int id) {
    key("code ${id}");
  }

  static void key(String it) {
    tell('key ${it}');
  }
}

class Keyboard {
  static void type(String text) {
    SystemEvents.keystroke('"${text}"');
  }

  static void stroke(String key, [String using]) {
    SystemEvents.keystroke(key + (using == null ? "" : " using ${using}"));
  }

  static void press(String key) {
    SystemEvents.key(key);
  }
}
