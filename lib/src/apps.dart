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

class DefaultBrowser {
  static void open(String url) {
    runAppleScriptSync('open location "${url}"');
  }
}

class GoogleChrome {
  static String APP = (() {
    var apps = Applications.list().map((it) => it.name).toList();

    if (apps.contains("Google Chrome")) {
      return "Google Chrome";
    } else if (apps.contains("Chromium")) {
      return "Chromium";
    } else if (apps.contains("Google Chrome Canary")) {
      return "Google Chrome Canary";
    } else {
      return null;
    }
  })();

  static void reload([String tab]) {
    tellTab("reload", tab);
  }

  static String tellTab(String act, [String tab]) {
    return tell("${act}${tab != null ? ' ${tab}' : ''}");
  }

  static void back([tab]) {
    tellTab("go back", tab);
  }

  static void forward([tab]) {
    tellTab("go forward", tab);
  }

  static void selectAll([tab]) {
    tellTab("select all", tab);
  }

  static void cutSelection([tab]) {
    tellTab("cut selection", tab);
  }

  static void copySelection([tab]) {
    tellTab("copy selection", tab);
  }

  static void pasteSelection([tab]) {
    tellTab("paste selection", tab);
  }

  static void undo([tab]) {
    tellTab("undo", tab);
  }

  static void redo([tab]) {
    tellTab("redo", tab);
  }

  static void stop([tab]) {
    tellTab("stop", tab);
  }

  static void viewSource([tab]) {
    tellTab("view source", tab);
  }

  static void executeJavaScript(String script, [tab]) {
    tell("execute ${tab != null ? tab + " " : ""} javascript \"${script}\"");
  }

  static void activate() {
    tell("activate");
  }

  static void enterPresentationMode([tab]) {
    tellTab("enter presentation mode ${tab}");
  }

  static void exitPresentationMode([tab]) {
    tellTab("exit presentation mode ${tab}");
  }

  static GoogleChromeWindow getMainWindow() {
    return new GoogleChromeWindow(1);
  }

  static GoogleChromeTab createTab(int window) {
    return new GoogleChromeTab(window, parseAppleScriptRecord(tell("get id of (make new tab at end of tabs of window ${window})")));
  }

  static List<GoogleChromeWindow> getWindows() {
    var r = tell("get index of every window");
    return parseAppleScriptRecord(r).map((it) {
      return new GoogleChromeWindow(it);
    }).toList();
  }

  static List<GoogleChromeTab> getTabs(int id) {
    return parseAppleScriptRecord(tell("get id of every tab of window ${id}")).map((it) => new GoogleChromeTab(id, it)).toList();
  }

  static String tell(String action) {
    return Applications.tell(APP, action);
  }

  static String getTabName(int window, int tab) {
    var r = tell("""
    get tab whose id is ${tab} of window ${window}
    """);

    print(r);

    return r;
  }
}

class GoogleChromeWindow {
  int id;

  GoogleChromeWindow(this.id);

  String getName() {
    return parseAppleScriptRecord(GoogleChrome.tell("get name of window ${id}"));
  }

  List<GoogleChromeTab> getTabs() {
    return GoogleChrome.getTabs(id);
  }
}

class GoogleChromeTab {
  int window;
  int id;

  GoogleChromeTab(this.window, this.id);

  String getName() => GoogleChrome.getTabName(window, id);
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

  static Set<int> getIds(String name) => runAppleScriptSync("""
  tell application "System Events"
    get id of every process whose name is "${name}"
  end tell
  """).split(", ").map(int.parse);

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
  static void activate({bool slow: false}) {
    SystemEvents.key("code 126 using {control down${slow ? ", shift down" : ""}}");
  }

  static void close({bool slow: false}) {
    SystemEvents.key("code 125 using {control down${slow ? ", shift down" : ""}}");
  }
}

class Dashboard {
  static void activate() {
    SystemEvents.key("code 123 using control down");
  }

  static void close() {
    SystemEvents.key("code 124 using control down");
  }
}

class Applications {
  static void activate(String name) {
    tellApplicationSync(name, "activate");
  }

  static void quit(String name) {
    tellApplicationSync(name, "quit");
  }

  static String getWindowTitle(String name, int index) {
    return tellApplicationSync(name, "get name of window ${index}");
  }

  static String tellUI(String name, String action) {
    return tell("System Events", """
    tell process "${name}"
      ${action}
    end tell
    """);
  }

  static void setFrontMost(String name, bool frontmost) {
    tellUI(name, "set frontmost to ${frontmost}");
  }

  static void makeFrontMost(String name) {
    setFrontMost(name, true);
  }

  static String getVersion(String name) => parseAppleScriptRecord(tell(name, "get version"));

  static int getWindowCount(String name) {
    return int.parse(tellApplicationSync(name, "count of Finder windows"));
  }

  static void closeAll(String name) {
    tell(name, "close every window");
  }

  static void reopen(String name) {
    tell(name, "reopen");
  }

  static Set<Application> list({bool normal: true}) {
    if (normal) {
      return parseAppleScriptRecord(runAppleScriptSync(r'''
      paragraphs of (do shell script "find /Applications/ -name \"*.app\" -maxdepth 1 | sed -e \"s/\\(.*\\)\\/\\([^\\/]*\\).app/\\2/g\"")
      ''')).toSet().map((it) => new Application(it));
    } else {
      return parseAppleScriptRecord(runAppleScriptSync(r'''
      paragraphs of (do shell script "find /Applications/ -name \"*.app\" -maxdepth 2 | sed -e \"s/\\(.*\\)\\/\\([^\\/]*\\).app/\\2/g\"")
      ''')).toSet().map((it) => new Application(it));
    }
  }

  static bool isInstalled(String name) => list().map((it) => it.name).contains(name);
  static Application get(String name) => new Application(name);

  static String tell(String name, String action) => tellApplicationSync(name, action);
}

class Application {
  final String name;

  Application(this.name);

  void launch() {
    Applications.activate(name);
  }

  int getWindowCount() => Applications.getWindowCount(name);
  Set<int> getIds() => TaskManager.getIds(name);

  void quit() {
    Applications.quit(name);
  }

  String getVersion() => Applications.getVersion(name);

  void reopen() {
    Applications.reopen(name);
  }

  String tell(String action) {
    return Applications.tell(name, action);
  }

  String getPath() {
    return Applications.get("System Events").tell("""
    POSIX path of (path to application "${name}")
    """);
  }

  bool isInstalled() => Applications.isInstalled(name);

  @override
  String toString() => name;
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

class Atom {
  static void activate() {
    tell("activate");
  }

  static void quit() {
    tell("quit");
  }

  static void createDocument() {
    tell("""
    activate
    delay 3
    make new document
    """);
  }

  static String tell(String action) {
    return Applications.tell("Atom", "activate");
  }

  static bool isInstalled() => Applications.list().any((it) => it.name == "Atom");
}

class TextEdit {
  static void activate() {
    tell("activate");
  }

  static void quit() {
    tell("quit");
  }

  static String tell(String action) {
    return Applications.tell("TextEdit", "activate");
  }
}
