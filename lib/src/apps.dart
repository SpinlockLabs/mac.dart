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

class Applications {
  static void activate(String name) {
    tellApplicationSync(name, "activate");
  }

  static int getWindowCount(String name) {
    var result = tellApplicationSync(name, "count of Finder windows");

    if (result.exitCode != 0) {
      return 0;
    }

    return int.parse(result.stdout.trim());
  }

  static void closeAll(String name) {
    tell(name, "close every window");
  }

  static void reopen(String name) {
    tell(name, "reopen");
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
