part of mac.utils;

class Files {
  static File getTempFile(String content) {
    var dir = Directory.systemTemp;

    return File("${dir.path}/${generateRandomString(10)}");
  }
}
