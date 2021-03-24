// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: UPL-1.0

import 'dart:io';

import 'package:errno/errno.dart';
import 'package:meta/meta.dart';

bool isNoSuchDirectoryCode(int errorCode) {
  // Ubuntu:
  // FileSystemException: Directory listing failed, path = '...'
  // (OS Error: No such file or directory, errno = 2)

  // MacOS:
  // FileSystemException: Directory listing failed, path = '...'
  // (OS Error: No such file or directory, errno = 2)

  // Windows:
  // FileSystemException: Directory listing failed, path = '...'
  // (OS Error: The system cannot find the path specified., errno = 3)

  if (Platform.isWindows && errorCode == WindowsErrors.pathNotFound) {
    return true;
  }

  // assuming we're on *nix
  return errorCode == LinuxErrors.noSuchFileOrDirectory;
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
  // (OS Error: The directory is not empty.

  if (Platform.isWindows && errorCode == WindowsErrors.dirNotEmpty) {
    return true;
  }

  if ((Platform.isMacOS || Platform.isIOS) && errorCode == DarwinErrors.directoryNotEmpty) {
    return true;
  }

  // assuming we are on *nix
  return errorCode == LinuxErrors.directoryNotEmpty;
}

bool _isNoFileCode(int errorCode) {
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

  return errorCode == 2;
}

bool isNoSuchPathCode(int errorCode) {
  return _isNoFileCode(errorCode) | isNoSuchDirectoryCode(errorCode);
}
