// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: UPL-1.0

import 'dart:io';

import 'package:errno/errno.dart';
import 'package:meta/meta.dart';

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
  // two different error codes (2,3).

  if (Platform.isWindows) {
    return errorCode == WindowsErrors.pathNotFound || errorCode == WindowsErrors.fileNotFound; 
  } else {
    // assuming we're on *nix
    return errorCode == LinuxErrors.noSuchFileOrDirectory;
  }
}


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