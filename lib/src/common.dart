part of osx;

class Common {
  static Future<bool> areHiddenFilesShown() => Defaults.get(Domains.FINDER, "AppleShowAllFiles");
  static Future setHiddenFilesShown(bool shown) => Defaults.set(Domains.FINDER, "AppleShowAllFiles", shown);
}

class Domains {
  static const String FINDER = "com.apple.finder";
}

class Volume {
  static int getVolume() {
    return int.parse(runAppleScriptSync("output volume of (get volume settings)"));
  }

  static bool isMuted() {
    return runAppleScriptSync("output of muted of (get volume settings)") == "true";
  }

  static void setVolume(int volume) {
    runAppleScriptSync("set volume output volume ${volume}");
  }

  static void setMuted(bool muted) {
    runAppleScriptSync("set volume ${muted ? 'with' : 'without'} output muted");
  }

  static void mute() => setMuted(true);
  static void unmute() => setMuted(false);
  static void toggleMuted() => setMuted(!isMuted());
}

class SystemInformation {
  static Map<String, dynamic> _info = parseAppleScriptRecord(runAppleScriptSync("system info"));

  static String getVersion() => runAppleScriptSync('system version of (system info)');
  static String getUser() => runAppleScriptSync('short user name of (system info)');
  static String getUserName() => runAppleScriptSync('long user name of (system info)');
  static String getComputerName() => runAppleScriptSync('computer name of (system info)');
  static String getHostName() => runAppleScriptSync('host name of (system info)');
  static String getUserLocale() => runAppleScriptSync('user locale of (system info)');
  static int getCpuSpeed() => int.parse(runAppleScriptSync('CPU speed of (system info)'));
  static int getPhysicalMemory() => int.parse(runAppleScriptSync('physical memory of (system info)'));
}

class System {
  static void beep() {
    runAppleScriptSync("beep");
  }
}

class Battery {
  static num getLevel() {
    var info = _info();
    info = info.replaceAll("\t", "; ");
    var x = info.split("; ")[1];
    x = x.substring(0, x.indexOf("%"));
    return num.parse(x);
  }

  static bool isCharging() {
    return _info().contains("charging;");
  }

  static bool isPluggedIn() {
    var info = _info();
    return info.contains("charging;") || info.contains("charged;");
  }

  static String _info() {
    return Process.runSync("pmset", ["-g", "batt"]).stdout.split("\n")[1].trim();
  }
}
