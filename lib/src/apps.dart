part of mac;

const fetchApps = r'''paragraphs of (do shell script "find /Applications/ -name \"*.app\" -maxdepth 1 | sed -e \"s/\\(.*\\)\\/\\([^\\/]*\\).app/\\2/g\"")''';
const fetchAppsTwoDeep = r'''paragraphs of (do shell script "find /Applications/ -name \"*.app\" -maxdepth 2 | sed -e \"s/\\(.*\\)\\/\\([^\\/]*\\).app/\\2/g\"")''';

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
    return Applications.tellSync("Finder", action);
  }

  static FinderWindow getFrontWindow() {
    return FinderWindow("front Finder window");
  }

  static void closeAll() {
    Applications.closeAll("Finder");
  }

  static List<FinderWindow> getWindows() {
    var count = getWindowCount();
    var windows = <FinderWindow>[];
    if (count == 0) {
      return windows;
    }

    for (var i = 1; i <= count; i++) {
      windows.add(FinderWindow(i));
    }
    return windows;
  }

  static int getWindowCount() => Applications.getWindowCount("Finder");

  static FinderWindow getWindow(dynamic id) => FinderWindow(id);
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

  static void reload([tab]) {
    tellTab("reload", tab);
  }

  static String tellTab(String act, [tab]) {
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

  static String getUrl(int tab) {
    return parseAppleScriptRecord(tell("get URL of tab ${tab}"));
  }

  static void setUrl(int tab, String url) {
    tell('''
    tell application "${APP}"
      set theWindows to every window
      repeat with theWindow in theWindows
        set theTabs to every tab of theWindow
        repeat with theTab in theTabs
          set theId to id of theTab
          if theId is ${tab} then
            set URL of theTab to "${url}"
          end if
        end repeat
      end repeat
    end tell
    ''');
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

  static String _withWindow(int id, String action,
      {String before, String after}) {
    return tell('''
    set theWindows to every window
    repeat with theWindow in theWindows
      if id of theWindow is ${id} then
        ${action}
      end if
    end repeat
    ${after}
    ''');
  }

  static GoogleChromeWindow getMainWindow() {
    return getWindows().first;
  }

  static GoogleChromeTab createTab(int window) {
    return GoogleChromeTab(
        window,
        parseAppleScriptRecord(tell(
            "get id of (make new tab at end of tabs of window ${window})")));
  }

  static int getWindowIndex(int id) {
    return parseAppleScriptRecord(_withWindow(id, """
    return index of theWindow
    """));
  }

  static List<GoogleChromeWindow> getWindows() {
    var r = tell("get id of every window");
    return parseAppleScriptRecord(r).map((it) {
      return GoogleChromeWindow(it);
    }).toList()
      ..sort((a, b) => b.id.compareTo(a.id));
  }

  static List<GoogleChromeTab> getTabs(int window) {
    return parseAppleScriptRecord(_withWindow(
        window,
        """
    set theTabs to every tab of theWindow
    repeat with theTab in theTabs
      set theId to the id of theTab
      set end of theTabIds to theId
    end repeat
    """,
        before: "set theTabIds to {}",
        after: "return theTabIds"));
  }

  static String tell(String action) {
    return Applications.tellSync(APP, action);
  }

  static GoogleChromeTab getActiveTab(int window) {
    var result = _withWindow(window, """
    return id of active tab
    """);

    return GoogleChromeTab(window, parseAppleScriptRecord(result));
  }

  static String getTabName(int id) {
    var result = runAppleScriptSync("""
    tell application "${APP}"
      set theWindows to every window
      repeat with theWindow in theWindows
        set theTabs to every tab of theWindow
        repeat with theTab in theTabs
          set theId to id of theTab
          if theId is ${id} then
            return name of theTab
          end if
        end repeat
      end repeat
    end tell
    """);

    return parseAppleScriptRecord(result);
  }
}

class GoogleChromeWindow {
  int id;

  GoogleChromeWindow(this.id);

  String getName() {
    return parseAppleScriptRecord(GoogleChrome.tell("""
    set theWindows to every window
    repeat with theWindow in theWindows
      set theId to the id of theWindow
      if theId is ${id} then
        return name of theWindow
      end if
    end repeat
    """));
  }

  GoogleChromeTab getActiveTab() {
    return GoogleChrome.getActiveTab(id);
  }

  GoogleChromeTab newTab() {
    return GoogleChrome.createTab(id);
  }

  List<GoogleChromeTab> getTabs() {
    return GoogleChrome.getTabs(id);
  }
}

class GoogleChromeTab {
  int window;
  int id;

  GoogleChromeTab(this.window, this.id);

  String getName() => GoogleChrome.getTabName(id);
  String getUrl() => GoogleChrome.getUrl(id);

  void executeJavaScript(String js) {
    GoogleChrome.executeJavaScript(js, id);
  }

  void reload() {
    GoogleChrome.reload(id);
  }

  void makeActiveTab() {
    GoogleChrome._withWindow(window, """
    set active tab index of theWindow to ${id}
    """);
  }

  void redo() {
    GoogleChrome.redo(id);
  }

  void undo() {
    GoogleChrome.undo(id);
  }

  void goto(String url) {
    GoogleChrome.setUrl(id, url);
  }
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
    return parseAppleScriptRecord(runAppleScriptSync('''
    tell application "System Events" to get name of every process whose background only is false
    ''')).toSet();
  }

  static Set<String> getTasks() {
    return parseAppleScriptRecord(runAppleScriptSync('''
    tell application "System Events" to get name of every process
    ''')).toSet().cast<String>();
  }

  static Set<int> getIds(String name) => runAppleScriptSync("""
  tell application "System Events"
    get id of every process whose name is "${name}"
  end tell
  """).split(", ").map(int.parse).cast<int>().toSet();

  static Set<String> getVisibleTasks() {
    return runAppleScriptSync('''
    tell application "System Events" to get name of every process whose visible is true
    ''').split(", ").toSet().cast<String>();
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
    Applications.activate("Mission Control");
  }

  static void close() {
    Applications.quit("Mission Control");
  }
}

class Dashboard {
  static void activate() {
    Applications.activate("Dashboard");
  }

  static void close() {
    Applications.quit("Dashboard");
  }
}

class Applications {
  static Future activate(String name) async {
    await tellApplication(name, """
    ignoring application responses
      activate
    end ignoring
    """);
  }

  static Future quit(String name) async {
    await tellApplication(name, """
    ignoring application responses
      quit
    end ignoring
    """);
  }

  static String getWindowTitle(String name, int index) {
    return tellApplicationSync(name, "get name of window ${index}");
  }

  static String tellUI(String name, String action) {
    return tellSync("System Events", """
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

  static String getVersion(String name) =>
      parseAppleScriptRecord(tellSync(name, "get version"));

  static int getWindowCount(String name) {
    return int.parse(tellApplicationSync(name, "count of Finder windows"));
  }

  static void closeAll(String name) {
    tellSync(name, "close every window");
  }

  static void reopen(String name) {
    tellSync(name, "reopen");
  }

  static Set<Application> list({bool normal = true}) {
    var rawApps = _fetchRawApplications(normal ? fetchApps : fetchAppsTwoDeep);
    var apps = rawApps.toSet().map((it) => Application(it)).toSet();
    return Set<Application>.from(apps);
  }

  static _fetchRawApplications(String appleScript) {
    return parseAppleScriptRecord(runAppleScriptSync(appleScript));
  }

  static String guessPath(String name) {
    var fname = "${name}.app";
    var search = [
      "/Applications",
      "/System/Library/CoreServices",
      "${SystemInformation.getHomeDirectory()}/Applications"
    ];

    for (var p in search) {
      var dir = Directory("${p}/${fname}");

      if (dir.existsSync()) {
        return dir.path;
      }
    }

    return null;
  }

  static ApplicationInfo getInfoPlist(String name) {
    return ApplicationInfo(
        PropertyLists.fromFile(getAppFile(name, "Contents/Info.plist")));
  }

  static File getAppFile(String name, String path) {
    return File(guessPath(name) + "/${path}");
  }

  static bool isInstalled(String name) =>
      list().map((it) => it.name).contains(name);
  static Application get(String name) => Application(name);

  static String tellSync(String name, String action) =>
      tellApplicationSync(name, action);
  static Future<String> tell(String name, String action) =>
      tellApplication(name, action);
}

class ApplicationInfo {
  final Map info;

  ApplicationInfo(this.info);

  String getBuildMachineOSBuild() {
    return getProperty("BuildMachineOSBuild");
  }

  String getBundleDisplayName() {
    return getProperty("CFBundleDisplayName");
  }

  String getBundleName() {
    return getProperty("CFBundleName");
  }

  String getBundleIdentifier() {
    return getProperty("CFBundleIdentifier");
  }

  String getBundleVersion() {
    return getProperty("CFBundleVersion");
  }

  String getBundleShortVersion() {
    return getProperty("CFBundleShortVersionString");
  }

  String getBundleIcon() {
    return getProperty("CFBundleIconFile");
  }

  String getBundlePackageType() {
    return getProperty("CFBundlePackageType");
  }

  String getBundleExecutable() {
    return getProperty("CFBundleExecutable");
  }

  String getSCMRevision() {
    return getProperty("SCMRevision");
  }

  String getProperty(String name) {
    return info[name];
  }

  @override
  String toString() {
    return JsonEncoder.withIndent("  ").convert(info);
  }
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
    return Applications.tellSync(name, action);
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
    return Applications.tellSync("System Events", action);
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

@deprecated
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
    return Applications.tellSync("Atom", "activate");
  }

  static bool isInstalled() => Applications.isInstalled("Atom");
}

class TextEdit {
  static void activate() {
    tell("activate");
  }

  static void quit() {
    tell("quit");
  }

  static String tell(String action) {
    return Applications.tellSync("TextEdit", "activate");
  }
}
