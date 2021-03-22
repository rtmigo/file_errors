// SPDX-FileCopyrightText: (c) 2020 Art Galkin <ortemeo@gmail.com>
// SPDX-License-Identifier: BSD-3-Clause




import 'dart:io';

import 'package:file_errors/10_files.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

void main() {

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync();
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });


  test('listIfExists when does not exist', () async {
    final unexisting = Directory(path.join(tempDir.path, "unexisting"));
    expect(listSyncOrEmpty(unexisting), []);
  });

  test('listIfExists when exists', () async {

    File(path.join(tempDir.path, "a.txt")).writeAsStringSync(":)");
    File(path.join(tempDir.path, "b.txt")).writeAsStringSync("(:");

    expect(listSyncOrEmpty(tempDir).map((e) => path.basename(e.path)).toSet(), {'b.txt', 'a.txt'});
  });

  test('isDirNotEmpty', () async {

    File(path.join(tempDir.path, "a.txt")).writeAsStringSync(":)");
    File(path.join(tempDir.path, "b.txt")).writeAsStringSync("(:");

    bool raised = false;
    try {
      tempDir.deleteSync(recursive: false);
    } on FileSystemException catch (e) {
      raised = true;
      expect(isDirectoryNotEmptyException(e), isTrue);
    }

    expect(raised, isTrue);
  });
}
