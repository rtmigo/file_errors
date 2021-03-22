// SPDX-FileCopyrightText: (c) 2020 Art Galkin <ortemeo@gmail.com>
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';


// also tried [ErrorCodes](https://git.io/JqnbR) but their codes for Windows
// (as for 2021-03) are totally different from
// (https://docs.microsoft.com/en-us/windows/win32/debug/system-error-codes--0-499-)
//
// class _WindowsCodes { ...
//   final int esrch = 3;       // WTF is that? WinAPI uses 3 (0x3) for ERROR_PATH_NOT_FOUND,
//                              // while ESRCH is for "no such process"...
//   final int enotempty = 41;  // Must be 145 etc.
// }

bool isFileNotFoundException(FileSystemException e) {
  if (Platform.isWindows && e.osError?.errorCode == WINDOWS_ERROR_PATH_NOT_FOUND)
    return true;
  if ((Platform.isMacOS||Platform.isIOS) && e.osError?.errorCode == MACOS_NO_SUCH_FILE)
    return true;
  // assuming we're on linux-like system
  if (e.osError?.errorCode==LINUX_ENOENT)
    return true;
  return false;
}

const int LINUX_ENOTEMPTY = 39;
const int LINUX_ENOENT = 2;

// As strange as it may sound, there is still
// no official list of macOS system errors in 2021
const int MACOS_NOT_EMPTY = 66;
const int MACOS_NO_SUCH_FILE = LINUX_ENOENT;

const int WINDOWS_DIR_NOT_EMPTY = 145; // 0x91
const int WINDOWS_ERROR_PATH_NOT_FOUND = 3; // 0x3

bool isDirectoryNotExistsCode(int errorCode) {

  // Ubuntu:
  // FileSystemException: Directory listing failed, path = '...'
  // (OS Error: No such file or directory, errno = 2)

  // MacOS:
  // FileSystemException: Directory listing failed, path = '...'
  // (OS Error: No such file or directory, errno = 2)

  // Windows:
  // FileSystemException: Directory listing failed, path = '...'
  // (OS Error: The system cannot find the path specified., errno = 3)

  if (Platform.isWindows && errorCode == WINDOWS_ERROR_PATH_NOT_FOUND) {
    return true;
  }

  // assuming we're on *nix
  return errorCode == LINUX_ENOENT;
}

bool isDirectoryNotEmptyCode(int errorCode)
{
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

  if (Platform.isWindows && errorCode == WINDOWS_DIR_NOT_EMPTY) {
    return true;
  }

  if ((Platform.isMacOS||Platform.isIOS) && errorCode == MACOS_NOT_EMPTY) {
    return true;
  }

  // assuming we are on *nix
  return errorCode == LINUX_ENOTEMPTY;
}

bool isFileNotExistsCode(int errorCode ) {
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


