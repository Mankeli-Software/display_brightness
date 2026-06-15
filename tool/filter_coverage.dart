// ignore_for_file: avoid_print
import 'dart:io';

void main() {
  final lcovFile = File('coverage/lcov.info');
  if (!lcovFile.existsSync()) {
    print('No coverage/lcov.info found!');
    return;
  }

  final lines = lcovFile.readAsLinesSync();
  final filteredLines = <String>[];
  var skipRecord = false;
  var currentRecord = <String>[];

  for (final line in lines) {
    currentRecord.add(line);
    if (line.startsWith('SF:')) {
      final path = line.substring(3);
      if (path.endsWith('.g.dart')) {
        skipRecord = true;
      }
    }
    if (line == 'end_of_record') {
      if (!skipRecord) {
        filteredLines.addAll(currentRecord);
      }
      currentRecord.clear();
      skipRecord = false;
    }
  }

  lcovFile.writeAsStringSync(filteredLines.map((l) => '$l\n').join());
  print('Filtered coverage/lcov.info successfully.');
}
