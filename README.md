# macOS for Dart

Dart package for macOS integration.

## Features

- Easy to use
- Dictation (Speech Recognition and TTS)
- Application Interaction (High Level API for working with applications)
- Scripting Helpers
- System Information
- User Interface

## Example

```dart
import "package:mac/mac.dart";

void main() {
  say("Your computer is named: ${SystemInformation.getComputerName()}");
  say("You are running macOS ${SystemInformation.getVersion()}");
  say("Battery is at ${Battery.getLevel()}%");
  say("There are ${Applications.list().length} apps installed");

  if (Finder.getWindowCount() == 0) {
    say("Finder is not open.");
  } else {
    say("Finder is open.");
  }

  var app = Applications.get("Textual 5");

  if (app.isInstalled()) {
    say("Textual 5 is installed");
  } else {
    say("Textual 5 is not installed.");
  }

  var result = UI.displayDialog("Open Mission Control?", buttons: [
    "Yes",
    "No"
  ]);

  if (result.button == "Yes") {
    say("Opening Mission Control");
    MissionControl.activate();
  }
}
```
