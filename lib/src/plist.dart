part of mac;

class _PropertyListParser {
  _handleElement(libxml.XmlElement elem){
    switch (elem.name.local) {
      case 'string':
        return elem.text;
      case 'real':
        return double.parse(elem.text);
      case 'integer':
        return int.parse(elem.text);
      case 'true':
        return true;
      case 'false':
        return false;
      case 'date':
        return DateTime.parse(elem.text);
      case 'data':
        var str = elem.text.trim().replaceAll(" ", "").replaceAll("\n", "").replaceAll("\t", "");
        return new Uint8List.fromList(CryptoUtils.base64StringToBytes(str));
      case 'array':
        return elem.children
        .where(_isElement)
        .map(_handleElement)
        .toList();
      case 'dict':
        return _handleDict(elem);
    }
  }

  Map _handleDict(libxml.XmlElement elem){
    var children = elem.children.where(_isElement);
    var key = children
    .where((elem) => elem.name.local == 'key')
    .map((elem) => elem.text);
    var values = children
    .where((elem) => elem.name.local != 'key')
    .map(_handleElement);
    return new Map.fromIterables(key, values);
  }

  dynamic parse(String input) {
    return _handleElement(libxml.parse(input).rootElement.children.where(_isElement).first);
  }

  bool _isElement(libxml.XmlNode node) => node is libxml.XmlElement;
}

_PropertyListParser _plistParser = new _PropertyListParser();

class PropertyLists {
  static dynamic fromString(String input) {
    if (!input.trim().startsWith("<")) {
      input = convert(input, "xml1");
    }

    return _plistParser.parse(input);
  }

  static dynamic fromFile(File file) {
    return fromString(file.readAsStringSync());
  }

  static String encode(dynamic input) {
    var builder = new libxml.XmlBuilder();
    void _handleValue(dynamic it) {
      if (it is String) {
        builder.element("string", nest: () {
          builder.text(it);
        });
      } else if (it is int) {
        builder.element("integer", nest: () {
          builder.text(it.toString());
        });
      } else if (it is double) {
        builder.element("real", nest: () {
          builder.text(it.toString());
        });
      } else if (it is DateTime) {
        builder.element("date", nest: () {
          builder.text(it.toIso8601String());
        });
      } else if (it is bool) {
        builder.element(it.toString());
      } else if (it is List<int>) {
        builder.element("data", nest: () {
          builder.text(CryptoUtils.bytesToBase64(it));
        });
      } else if (it is List) {
        builder.element("array", nest: () {
          for (var e in it) {
            _handleValue(e);
          }
        });
      } else if (it is Map) {
        builder.element("dict", nest: () {
          for (var key in it.keys) {
            builder.element("key", nest: () {
              builder.text(key);
            });

            _handleValue(it[key]);
          }
        });
      } else {
        throw new Exception("Invalid Value: ${it}");
      }
    }

    _handleValue(input);

    return builder.build().toXmlString(pretty: true, indent: "  ");
  }

  static File writeFile(dynamic input, File file) {
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    return file..writeAsStringSync(encode(input));
  }

  static String convert(String input, String format) {
    var file = Files.getTempFile(input);
    file.writeAsStringSync(input);
    var result = Process.runSync("plutil", ["-convert", format, file.path]);
    if (result.exitCode != 0) {
      throw new Exception("Failed to convert plist.");
    }
    file.deleteSync();
    return result.stdout.trim();
  }
}
