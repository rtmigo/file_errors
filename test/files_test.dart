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

  test('list non-existent directory', () async {
    final nonExistentDir = Directory(path.join(tempDir.path, 'nonExistent'));
    bool caught = false;
    try {
      nonExistentDir.listSync();
    } on FileSystemException catch (e)
    {
      caught = true;
      expect(isDirectoryNotExistsCode(e.osError!.errorCode), isTrue);
    }
    expect(caught, true);
  });

  test('delete non-empty directory', () async {
    File(path.join(tempDir.path, 'file.txt')).writeAsStringSync('^_^');

    bool caught = false;
    try {
      tempDir.deleteSync();
    } on FileSystemException catch (e)
    {
      caught = true;
      //expect(isDirectoryNotExistsCode(e.osError!.errorCode), isTrue);
      rethrow;
    }
    expect(caught, true);
  });



  // test('listIfExists when does not exist', () async {
  //   final nonExistentDir = Directory(path.join(tempDir.path, 'nonExistent'));
  //   expect(listSyncOrEmpty(nonExistentDir), []);
  // });
  //
  // test('listIfExists when exists', () async {
  //
  //   File(path.join(tempDir.path, 'a.txt')).writeAsStringSync('^_^');
  //   File(path.join(tempDir.path, 'b.txt')).writeAsStringSync('^_^');
  //
  //   expect(listSyncOrEmpty(tempDir).map((e) => path.basename(e.path)).toSet(), {'b.txt', 'a.txt'});
  // });
  //
  // test('isDirNotEmpty', () async {
  //
  //   File(path.join(tempDir.path, 'a.txt')).writeAsStringSync('^_^');
  //   File(path.join(tempDir.path, 'b.txt')).writeAsStringSync('^_^');
  //
  //   bool raised = false;
  //   try {
  //     tempDir.deleteSync(recursive: false);
  //   } on FileSystemException catch (e) {
  //     raised = true;
  //     expect(isDirectoryNotEmptyException(e), isTrue);
  //   }
  //
  //   expect(raised, isTrue);
  // });
}
