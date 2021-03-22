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

  test('list non-existent directory', ()  {
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

  test('delete non-empty directory', () {
    File(path.join(tempDir.path, 'file.txt')).writeAsStringSync('^_^');

    bool caught = false;
    try {
      tempDir.deleteSync();
    } on FileSystemException catch (e)
    {
      caught = true;
      expect(isDirectoryNotEmptyCode(e.osError!.errorCode), isTrue);
      rethrow;
    }
    expect(caught, true);
  });

  test('open non-existent file ', () async {


    bool caught = false;
    try {
      File(path.join(tempDir.path, 'file.txt')).openSync(mode: FileMode.read);
    } on FileSystemException catch (e)
    {
      caught = true;
      //expect(isDirectoryNotEmptyCode(e.osError!.errorCode), isTrue);
      rethrow;
    }
    expect(caught, true);
  });

}
