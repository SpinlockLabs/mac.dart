library osx.utils;

import "dart:async";
import "dart:io";
import "dart:math";
import "dart:convert";

part "src/utils/http.dart";
part "src/utils/time.dart";
part "src/utils/files.dart";

String generateRandomString(int length) {
  var random = new Random();
  var chars = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
    "I",
    "J",
    "K",
    "L",
    "M",
    "N",
    "O",
    "P",
    "Q",
    "R",
    "S",
    "T",
    "U",
    "V",
    "W",
    "X",
    "Y",
    "Z",
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9"
  ];

  var builder = new StringBuffer();
  for (var i = 1; i <= length; i++) {
    builder.write(chars[random.nextInt(chars.length)]);
  }
  return builder.toString();
}
