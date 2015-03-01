part of osx;

class Defaults {
  static List<String> listDomains() {
    return Process.runSync("defaults", ["domains"]).stdout.trim().split(", ");
  }

  static Map<String, dynamic> read() {
    var out = {};

    for (var domain in listDomains()) {
      out[domain] = readDomain(domain);
    }

    return out;
  }

  static dynamic readDomain(String domain) {
    var result = Process.runSync("defaults", ["export", domain, "-"]);

    if (result.exitCode != 0) {
      throw new Exception("Failed to read domain: ${domain}");
    }

    var out = result.stdout.trim();

    return PropertyLists.fromString(out);
  }

  static void set(String domain, String key, dynamic value) {
    var result = Process.runSync("defaults", ["write", key, value.toString()]);
    if (result.exitCode != 0) {
      throw new Exception("Failed to set ${domain}@${key} to ${value}");
    }
  }

  static dynamic get(String domain, String key) {
    return readDomain(domain)[key];
  }

  static dynamic write(String domain, String key, dynamic value) {
    var data = readDomain(domain);
    data[key] = value;
    importDomain(domain, data);
    return data;
  }

  static void importDomain(String domain, dynamic value) {
    var file = Files.getTempFile(PropertyLists.encode(value));
    var result = Process.runSync("defaults", ["import", domain, file.path]);

    file.deleteSync();

    if (result.exitCode != 0) {
      throw new Exception("Failed to import data into ${domain}");
    }
  }
}
