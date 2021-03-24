// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: UPL-1.0

import 'dart:io';

import 'package:errno/errno.dart';
import 'package:meta/meta.dart';

@internal
bool isNoSuchFileOrDirectoryCode(int errorCode) {
  //
  // Reading a non-existent file in an existing directory
  // ----------------------------------------------------
  //
  // Ubuntu:
  // FileSystemException: Cannot open file, path = '...'
  // (OS Error: No such file or directory, errno = 2)
  //
  // Windows:
  // FileSystemException: Cannot open file, path = '...'
  // (OS Error: The system cannot find the file specified., errno = 2)
  //
  // MacOS:
  // FileSystemException: Cannot open file, path = '...'
  // (OS Error: No such file or directory, errno = 2)
  //
  //
  // Reading a file in a non-existent directory
  // ------------------------------------------
  //
  // Ubuntu:
  // FileSystemException: Directory listing failed, path = '...'
  // (OS Error: No such file or directory, errno = 2)
  //
  // MacOS:
  // FileSystemException: Directory listing failed, path = '...'
  // (OS Error: No such file or directory, errno = 2)
  //
  // Windows:
  // FileSystemException: Directory listing failed, path = '...'
  // (OS Error: The system cannot find the path specified., errno = 3)
  //
  /////
  //
  // So for POSIX both problems are ENOENT (2), and Windows returns 
  // two different error codes.

  if (Platform.isWindows) {
    return errorCode == WindowsErrors.pathNotFound || errorCode == WindowsErrors.fileNotFound; 
  } else {
    // assuming we're on *nix
    return errorCode == LinuxErrors.noSuchFileOrDirectory;
  }
}

// @internal
// bool maybe_nonexistentFile_inExistingDirectory(int errorCode) {
//   // when we try to read a non-existent file in existing
//   // directory, all OSs return the same error:
//   // ENOENT or ERROR_FILE_NOT_FOUND
//   //
//   // But only on Windows we can tell that the missing
//   // is the file. On POSIX we will get the same errors
//   // when opening file in missing directory.
//
//   assert(WindowsErrors.fileNotFound==2);
//   assert(DarwinErrors.noSuchFileOrDirectory==2);
//   assert(LinuxErrors.noSuchFileOrDirectory==2);
//
//   // POSIX returns ENOENT (so we have no idea, whether
//   // it's directory of file problem), and Windows
//   // returns ERROR_PATH_NOT_FOUND which is precisely for
//   // directories
//
//   // Ubuntu:
//   // FileSystemException: Cannot open file, path = '...'
//   // (OS Error: No such file or directory, errno = 2)
//   //
//   // Windows:
//   // FileSystemException: Cannot open file, path = '...'
//   // (OS Error: The system cannot find the file specified., errno = 2)
//   //
//   // MacOS:
//   // FileSystemException: Cannot open file, path = '...'
//   // (OS Error: No such file or directory, errno = 2)
//
//   return errorCode == 2;
// }


bool isNotEmptyCode(int errorCode) {
  // Ubuntu:
  // FileSystemException: Deletion failed, path = '...'
  // (OS Error: Directory not empty, errno = 39)
  //
  // MacOS:
  // FileSystemException: Deletion failed, path = '...'
  // (OS Error: Directory not empty, errno = 66)
  //
  // Windows:
  // FileSystemException: Deletion failed, path = '...'
  // (OS Error: The directory is not empty., errno = 145)

  if (Platform.isWindows && errorCode == WindowsErrors.dirNotEmpty) {
    return true;
  }

  if ((Platform.isMacOS || Platform.isIOS) && errorCode == DarwinErrors.directoryNotEmpty) {
    return true;
  }

  // assuming we are on *nix
  return errorCode == LinuxErrors.directoryNotEmpty;
}


// bool isNoSuchPathCode(int errorCode) {
//   return maybe_nonexistentFile_inExistingDirectory(errorCode) | either_file_or_parent_dir_missing(errorCode);
// }
