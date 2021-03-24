// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:file_errors/file_errors.dart';
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
        expect(caught, isTrue, reason: 'there were no exceptions');
      }
    });
  }

  group('non-existent directory', ()
  {
    // error
    testErrorCode('list',
        //mustMatchErrorCode: [isNoSuchPathCode, ],
        mustMatchException: [(exc)=>exc.isNoSuchFileOrDirectory],
        mustNotMatchException: [(exc)=>exc.isDirectoryNotEmpty],
        callForError: () {
          final nonExistentDir = Directory(path.join(tempDir.path, 'nonExistent'));
          nonExistentDir.listSync();
        });

    // error
    testErrorCode('delete',
        //mustMatchErrorCode: [isNoSuchPathCode, ],
        mustMatchException: [(exc)=>exc.isNoSuchFileOrDirectory],
        mustNotMatchException: [(exc)=>exc.isDirectoryNotEmpty],
        callForError: () {
          final nonExistentDir = Directory(path.join(tempDir.path, 'nonExistent'));
          nonExistentDir.deleteSync();
        });

    // error
    testErrorCode('open file for reading',
        mustMatchErrorCode: [isNoSuchFileOrDirectoryCode],
        mustMatchException: [(exc)=>exc.isNoSuchFileOrDirectory],
        mustNotMatchException: [(exc)=>exc.isDirectoryNotEmpty],
        callForError: () {
          File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.read);
        });

    // error
    testErrorCode('open file for writing',
        mustMatchException: [(exc)=>exc.isNoSuchFileOrDirectory],
        mustMatchErrorCode: [isNoSuchFileOrDirectoryCode],
        callForError: () {
          File(path.join(tempDir.path, 'non_existent/file.txt')).openSync(mode: FileMode.write);
        });

    // error
    testErrorCode('create file',
        mustMatchException: [(exc)=>exc.isNoSuchFileOrDirectory],
        mustMatchErrorCode: [isNoSuchFileOrDirectoryCode],
        callForError: ()=>File(path.join(tempDir.path, 'non_existent/file.txt')).createSync());

    // no error
    testErrorCode('doing nothing', 
        callBefore: () {
          Directory(path.join(tempDir.path, 'nonExistent'));
        });
  });

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


  group('existing directory', ()
  {
    // no errors
    testErrorCode('open file for writing',
      callBefore: () {
        File(path.join(tempDir.path, 'file.txt')).openSync(mode: FileMode.write);
      });

    // no errors
    testErrorCode('create file',
      callBefore: () {
        File(path.join(tempDir.path, 'file.txt')).createSync();
      });

    // error
    testErrorCode('open file for reading',
      mustMatchException: [(exc)=>exc.isNoSuchFileOrDirectory],
      mustNotMatchException: [],
      callForError: () {
        File(path.join(tempDir.path, 'file.txt')).openSync(mode: FileMode.read);
      }, );

    // error
    testErrorCode('delete non-empty directory',
        //reraise: true,
        mustMatchErrorCode: [isNotEmptyCode],
        mustMatchException: [(exc)=>exc.isDirectoryNotEmpty],
        mustNotMatchException: [(exc)=>exc.isNoSuchFileOrDirectory],
        callBefore: () => File(path.join(tempDir.path, 'file.txt')).openSync(mode: FileMode.write),
        callForError: ()=>tempDir.deleteSync());
  });

  //**group('deleting directory', () {}

  // i was unable to simulate locking.
  // it seems to be tied to a process, but not to a particular object
  /*
  testErrorCode('trying to open locked file',

      callForError: () {
        final p = path.join(tempDir.path, 'locked.txt');
        final locked = File(p);
        //locked.writeAsStringSync('lock me');
        RandomAccessFile? raf;
        try {
          raf = locked.openSync(mode: FileMode.write);
          raf.lockSync(FileLock.blockingExclusive, 0, 6);
          raf.writeStringSync('written in exclusive mode');

          File(p).writeAsStringSync('haha');

        }
        finally {
          if (raf!=null ) {
            raf.unlockSync();
            raf.closeSync();
          }
        }

        print('READ ${File(p).readAsStringSync()}');
      });*/
}