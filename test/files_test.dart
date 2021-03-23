// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:file_errors/codes.dart';
import 'package:file_errors/exceptions.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

typedef CheckCodeCallback = bool Function(int x);
typedef CheckExceptionCallback = bool Function(FileSystemException exc);

void main() {

  late Directory tempDir;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync();
  });

  tearDown(() {
    try {
      tempDir.deleteSync(recursive: true);
    } on FileSystemException catch (e) {
      print('WARNING: Failed to delete temp directory.');
      // sometimes it fails on windows with
      // FileSystemException: Deletion failed, path = '...'
      // (OS Error: The process cannot access the file because it is being used by another process.
      // , errno = 32)
      print(e);
    }
  });

  void testErrorCode(String testName, {
    void Function()? callBefore,
    void Function()? callForError, 
    List<CheckCodeCallback>? mustMatchErrorCode,
    List<CheckExceptionCallback>? mustMatchException,
    List<CheckExceptionCallback>? mustNotMatchException,
    bool reraise=false
  }) {

    if ((mustMatchErrorCode!=null || mustMatchException!=null || mustNotMatchException!=null) && callForError==null) {
      throw ArgumentError('no callForError');
    }

    test(testName, () {
      callBefore?.call();
      if (callForError!=null) {
        bool caught = false;
        try {
          callForError.call();
        } on FileSystemException catch (e) {
          caught = true;
          if (reraise) {
            rethrow;
          }
          if (mustMatchErrorCode != null) {
            for (final func in mustMatchErrorCode) {
              expect(func(e.osError!.errorCode), isTrue, reason: func.toString());
            }
          }
          if (mustMatchException != null) {
            for (final func in mustMatchException) {
              expect(func(e), isTrue, reason: func.toString());
            }
          }
          if (mustNotMatchException != null) {
            for (final func in mustNotMatchException) {
              expect(func(e), isFalse, reason: func.toString());
            }
          }

        }
        expect(caught, isTrue);
      }
    });
  }

  group('non-existent directory', ()
  {
    // error
    testErrorCode('list',
        mustMatchErrorCode: [isNoDirectoryCode],
        callForError: () {
          final nonExistentDir = Directory(path.join(tempDir.path, 'nonExistent'));
          nonExistentDir.listSync();
        });

    // error
    testErrorCode('open file for reading',
        mustMatchErrorCode: [isNoDirectoryCode, isNoFileOrParentCode],
        mustMatchException: [isNoDirectoryException, isNoFileOrParentException],
        mustNotMatchException: [isNotEmptyException],
        callForError: () {
          File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.read);
        });

    // error
    testErrorCode('open file for writing',
        mustMatchErrorCode: [isNoDirectoryCode, isNoFileOrParentCode],
        callForError: () {
          File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.write);
        });

    // error
    testErrorCode('create file',
        mustMatchErrorCode: [isNoDirectoryCode, isNoFileOrParentCode],
        callForError: ()=>File(path.join(tempDir.path, 'non_existent/file.txt')).createSync());

    // no error
    testErrorCode('doing nothing', 
        callBefore: () {
          Directory(path.join(tempDir.path, 'nonExistent'));
        });
  });

  // error
  testErrorCode('delete non-empty directory',
      mustMatchErrorCode: [isNotEmptyCode],
      mustMatchException: [isNotEmptyException],
      mustNotMatchException: [isNoFileException],
      callBefore: () => File(path.join(tempDir.path, 'file.txt')).openSync(mode: FileMode.write),
      callForError: ()=>tempDir.deleteSync());

  // no error
  testErrorCode('createSync does nothing for existent files',
      callBefore: () {
        File(path.join(tempDir.path, 'file.txt')).writeAsString('^_^');
        File(path.join(tempDir.path, 'file.txt')).createSync();
      });

  // no error
  testErrorCode('createSync does nothing for existent directories',
      callBefore: () {
        Directory(path.join(tempDir.path, 'subdir')).createSync();
        Directory(path.join(tempDir.path, 'subdir')).createSync();
      });


  group('non-existent file in existing directory', ()
  {
    // no errors
    testErrorCode('open for writing',
      callBefore: () {
        File(path.join(tempDir.path, 'file.txt')).openSync(mode: FileMode.write);
      });

    // no errors
    testErrorCode('create',
      callBefore: () {
        File(path.join(tempDir.path, 'file.txt')).createSync();
      });

    // error
    testErrorCode('open for reading',
      mustMatchErrorCode: [isNoFileCode, isNoFileOrParentCode],
      mustMatchException: [isNoFileException, isNoFileOrParentException],
      mustNotMatchException: [isNotEmptyException],
      callForError: () {
        File(path.join(tempDir.path, 'file.txt')).openSync(mode: FileMode.read);
      }, );
  });
}