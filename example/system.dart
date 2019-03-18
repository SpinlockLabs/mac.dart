import 'package:mac/mac.dart';

void main() {
  print('macOS Version: ${SystemInformation.getVersion()}');
  print('Computer Name: ${SystemInformation.getComputerName()}');
  print('Hostname: ${SystemInformation.getHostName()}');
}
