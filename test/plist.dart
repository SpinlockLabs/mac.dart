import 'package:test/test.dart';

import 'package:mac/mac.dart';

const String examplePlist = """
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>quiz</key>
	<dict>
		<key>question</key>
		<array>
			<dict>
				<key>text</key>
				<string>What does 'API' stand for?</string>
				<key>answer</key>
				<string>API stands for Application Programming Interface.</string>
			</dict>
			<dict>
				<key>text</key>
				<string>What's so good about pragmatic REST?</string>
				<key>answer</key>
				<string>It's focused on the api consumer, so it makes it easier for developers to contribute to your app library!</string>
			</dict>
		</array>
		
	</dict>
</dict>
</plist>
""";

void main() {
  test('load large string plist', () {
    var plist = PropertyLists.fromString(examplePlist);
    expect(plist["quiz"]["question"].length, equals(2));
    expect(plist["quiz"]["question"][0]["text"],
        equals("What does 'API' stand for?"));
    expect(plist["quiz"]["question"][1]["text"],
        equals("What's so good about pragmatic REST?"));
  });
}
