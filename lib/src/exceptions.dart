// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: UPL-1.0

import 'dart:io';

import 'package:file_errors/src/codes.dart';

import 'codes.dart';

bool _checkCode(FileSystemException exception, bool Function(int) check) {
  int? code = exception.osError?.errorCode;
  return (code != null) && check(code);
}

/// Adds cross-platform extensions that give explanations to common problems when accessing files.
extension FileSystemExceptionExplanation on FileSystemException {

  /// Occurs when the requested file or directory does not exist;
  /// or its parent directory does not exist.
  bool get isNoSuchFileOrDirectory {
    return _checkCode(this, isNoSuchFileOrDirectoryCode);
  }

  /// Occurs when you try to non-recursively delete a directory but it contains files.
  bool get isDirectoryNotEmpty {
    return _checkCode(this, isNotEmptyCode);
  }
}
