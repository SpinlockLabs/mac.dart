part of osx;

class Defaults {
  static Future<List<String>> listDomains() async {
    return (await Process.run("defaults", ["domains"])).stdout.trim().split(", ");
  }

  static Future<Map<String, dynamic>> read() async {
    var out = {};

    for (var domain in await listDomains()) {
      out[domain] = await readDomain(domain);
    }

    return out;
  }

  static Future<dynamic> readDomain(String domain) async {
    var result = await Process.run("defaults", ["export", domain, "-"]);

    if (result.exitCode != 0) {
      throw new Exception("Failed to read domain: ${domain}");
    }

    var out = result.stdout.trim();

    return await PropertyLists.fromString(out);
  }

  static Future<bool> set(String domain, String key, dynamic value) async {
    return (await Process.run("defaults", ["write", key, value.toString()])).exitCode == 0;
  }

  static Future<dynamic> get(String domain, String key) async {
    return (await readDomain(domain))[key];
  }

  static Future<dynamic> write(String domain, String key, dynamic value) async {
    var data = await readDomain(domain);
    data[key] = value;
    importDomain(domain, data);
    return data;
  }

  static Future importDomain(String domain, dynamic value) async {
    var proc = await Process.start("defaults", ["import", domain, "-"]);
    proc.stdin.add(UTF8.encode(PropertyLists.encode(value)));
    await proc.stdin.close();
    var exitCode = await proc.exitCode;

    if (exitCode != 0) {
      throw new Exception("Failed to import data into ${domain}");
    }
  }
}
