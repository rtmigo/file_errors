// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: UPL-1.0

import 'dart:io';

import 'package:file_errors/src/codes.dart';

import 'codes.dart';

bool _checkCode(FileSystemException exception, bool Function(int) check) {
  int? code = exception.osError?.errorCode;
  return (code != null) && check(code);
}

extension FileSystemExceptionExplanation on FileSystemException {
  bool get isNoSuchFileOrDirectory {
    return _checkCode(this, isNoSuchFileOrDirectoryCode);
  }

  bool get isDirectoryNotEmpty {
    return _checkCode(this, isNotEmptyCode);
  }
}
