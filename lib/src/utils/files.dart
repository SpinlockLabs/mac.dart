part of osx.utils;

class Files {
  static File getTempFile(String content) {
    var dir = Directory.systemTemp;

    return new File("${dir.path}/${generateRandomString(10)}");
  }
}
