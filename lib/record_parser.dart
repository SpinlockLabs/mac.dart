library osx._record_parser;

import "package:petitparser/petitparser.dart";

class RecordGrammarDefinition extends GrammarDefinition {
  final _escapeTable = const {
    '\\': '\\',
    '/': '/',
    '"': '"',
    'b': '\b',
    'f': '\f',
    'n': '\n',
    'r': '\r',
    't': '\t'
  };

  @override
  start() => ref(value).end();

  value() => ref(dict) | ref(array) | ref(numberValue) | ref(stringValue) | ref(alias) | ref(data) | ref(dictEntry) | ref(undefinedValue) | ref(unknown);
  dict() => char("{") & ref(dictEntry).separatedBy(char(","), includeSeparators: false) & char("}");
  dictEntry() => ref(keyString) & char(":") & ref(value);
  array() => char("{") & ref(value).separatedBy(char(","), includeSeparators: false) & char("}");
  alias() => string("alias ") & ref(stringValue);
  stringValue() => char('"')
    & ref(characterPrimitive).star()
    & char('"');

  keyString() => ref(characterPrimitive).plusLazy(char(":")).flatten();

  characterPrimitive() => ref(characterNormal)
    | ref(characterEscape)
    | ref(characterOctal);
  characterNormal() => pattern('^"\\');
  characterEscape() => char('\\')
  & pattern(new List.from(_escapeTable.keys).join());
  characterOctal() => string('\\u').seq(pattern("0-9A-Fa-f").times(4).flatten());
  data() => string("\u00ABdata ") & any().plus() & char("\u00AB");
  numberValue() => (char('-').optional()
    & char('0').or(digit().plus())
    & char('.').seq(digit().plus()).optional()
    & pattern('eE').seq(pattern('-+').optional()).seq(digit().plus()).optional()).flatten();
  undefinedValue() => any().starGreedy((char("}") | char("\n") | char(",")));
  unknown() => any().plus().flatten();
}

class RecordGrammar extends GrammarParser {
  RecordGrammar() : super(new RecordGrammarDefinition());
}

class RecordParserDefinition extends RecordGrammarDefinition {
  @override
  dict() => super.dict().map((it) {
    var map = {};
    for (var x in it[1]) {
      map[x.keys.first] = x.values.first;
    }
    return map;
  });

  @override
  dictEntry() => super.dictEntry().map((it) {
    return {
      it[0]: it[2]
    };
  });

  @override
  array() => super.array().map((it) {
    return it[1];
  });

  @override
  alias() => super.alias().map((it) {
    return it[1];
  });

  @override
  stringValue() => super.stringValue().map((it) {
    return it[1].join();
  });

  @override
  data() => super.data().map((it) {
    return it[1];
  });

  @override
  numberValue() => super.numberValue().map((it) {
    return num.parse(it);
  });

  @override
  undefinedValue() => super.undefinedValue().map((it) {
    return it.join();
  });
}

class RecordParser extends GrammarParser {
  RecordParser() : super(new RecordParserDefinition());
}
