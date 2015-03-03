library osx.helper;

import "dart:io";
import "package:caller_info/caller_info.dart";

class Helper {
  static void init() {
    var info = _getCallerInfo();
    var n = info.file.toFilePath();
    var sourceFile = new File(n);
    var root = sourceFile.parent.parent;
    var helperDir = new Directory("${root.path}/helper");

  }
}

CallerInfo _getCallerInfo() {
  return new CallerInfo();
}
