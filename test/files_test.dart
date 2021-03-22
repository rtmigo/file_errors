// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:file_errors/10_files.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

//import '../lib/10_files.dart';

//import '../lib/10_files.dart';

void main() {

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync();
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  void testErrorCode(String testName, void Function() errorAction, {bool Function(int x)? isXxx, bool expectException=true, bool raise=false}) {
    test(testName, ()
    {
      bool caught = false;
      try {
        errorAction();
      } on FileSystemException catch (e) {
        caught = true;
        if (raise) {
          rethrow;
        }
        if (isXxx!=null) {
          expect(isXxx(e.osError!.errorCode), isTrue);
        }
      }
      expect(caught, expectException);
    });
  }

  group('non-existent directory', ()
  {
    testErrorCode('list', () {
      final nonExistentDir = Directory(path.join(tempDir.path, 'nonExistent'));
      nonExistentDir.listSync();
    }, isXxx: isDirectoryNotExistsCode);

    testErrorCode('open file for reading', () {
      File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.read);
    }, isXxx: isDirectoryNotExistsCode);

    testErrorCode('open file for writing', () {
      File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.write);
    }, isXxx: isDirectoryNotExistsCode);

    testErrorCode('create file', () {
      File(path.join(tempDir.path, 'non_existent/file.txt')).createSync();
    }, isXxx: isDirectoryNotExistsCode);

    testErrorCode('doing nothing', () {
      Directory(path.join(tempDir.path, 'nonExistent'));
    }, expectException: false);
  });

  group('non-existent file', ()
  {
    testErrorCode('open for writing', () {
      File(path.join(tempDir.path, 'file.txt')).openSync(mode: FileMode.write);
    }, expectException: false);
    //
    // testErrorCode('open file', () {
    //   File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.read);
    // }, isXxx: isDirectoryNotExistsCode);
    //
    // testErrorCode('open file', () {
    //   File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.write);
    // }, isXxx: isDirectoryNotExistsCode);
    //
    // testErrorCode('create file', () {
    //   File(path.join(tempDir.path, 'non_existent/file.txt')).createSync();
    // }, isXxx: isDirectoryNotExistsCode);
    //
    // testErrorCode('doing nothing', () {
    //   Directory(path.join(tempDir.path, 'nonExistent'));
    // }, expectException: false);
  });  


  // test('list non-existent directory', ()  {
  //   final nonExistentDir = Directory(path.join(tempDir.path, 'nonExistent'));
  //   bool caught = false;
  //   try {
  //     nonExistentDir.listSync();
  //   } on FileSystemException catch (e)
  //   {
  //     caught = true;
  //     expect(isDirectoryNotExistsCode(e.osError!.errorCode), isTrue);
  //   }
  //   expect(caught, true);
  // });
  //
  // test('open file for reading in non-existent directory', () {
  //   // same as open non-existent file
  //   bool caught = false;
  //   try {
  //     File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.read);
  //   } on FileSystemException catch (e) {
  //     caught = true;
  //     // ubu
  //     //    FileSystemException: Cannot open file, path = '/tmp/IOYRHX/non_existent/file.txt'
  //     //    (OS Error: No such file or directory, errno = 2)
  //     //
  //     //throw;
  //     expect(isDirectoryNotExistsCode(e.osError!.errorCode), isTrue);
  //
  //   }
  //   expect(caught, true);
  // });
  //
  // test('delete non-empty directory', () {
  //   File(path.join(tempDir.path, 'file.txt')).writeAsStringSync('^_^');
  //
  //   bool caught = false;
  //   try {
  //     tempDir.deleteSync();
  //   } on FileSystemException catch (e)
  //   {
  //     caught = true;
  //     expect(isDirectoryNotEmptyCode(e.osError!.errorCode), isTrue);
  //   }
  //   expect(caught, true);
  // });
  //
  // group('file not exists |', ()
  // {
  //   test('open non-existent file', () {
  //     bool caught = false;
  //     try {
  //       File(path.join(tempDir.path, 'file.txt')).openSync(mode: FileMode.read);
  //     } on FileSystemException catch (e) {
  //       caught = true;
  //       expect(isFileNotExistsCode(e.osError!.errorCode), isTrue);
  //     }
  //     expect(caught, true);
  //   });
  //
  //
  //
  //   // test('open file for writing in non-existent directory', () {
  //   //   // same as open non-existent file
  //   //   bool caught = false;
  //   //   try {
  //   //     File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.write);
  //   //   } on FileSystemException catch (e) {
  //   //     caught = true;
  //   //     expect(isFileNotExistsCode(e.osError!.errorCode), isTrue);
  //   //   }
  //   //   expect(caught, true);
  //   // });
  //
  //   // test('create file for writing in non-existent directory', () {
  //   //   // same as open non-existent file
  //   //   bool caught = false;
  //   //   try {
  //   //     File(path.join(tempDir.path, 'non_existent/file.txt')).createSync();
  //   //   } on FileSystemException catch (e) {
  //   //     caught = true;
  //   //     expect(isFileNotExistsCode(e.osError!.errorCode), isTrue);
  //   //   }
  //   //   expect(caught, true);
  //   // });
  //
  // });


}
