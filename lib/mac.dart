library mac;

import "dart:async";
import "dart:convert";
import "dart:io";
import "dart:typed_data";

import "package:xml/xml.dart" as libxml;
import "package:crypto/crypto.dart";

import "package:mac/utils.dart";
import "package:mac/record_parser.dart";

import "src/where_am_i.dart";

export "dart:io" show sleep;

part "src/apps.dart";
part "src/plist.dart";
part "src/dictation.dart";
part "src/defaults.dart";
part "src/script.dart";
part "src/common.dart";
part "src/ui.dart";

const Duration ONE_SECOND = const Duration(seconds: 1);
const Duration TWO_SECONDS = const Duration(seconds: 2);
const Duration THREE_SECONDS = const Duration(seconds: 3);
const Duration FIVE_SECONDS = const Duration(seconds: 5);
const Duration TEN_SECONDS = const Duration(seconds: 10);
