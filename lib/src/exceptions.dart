// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: UPL-1.0

import 'dart:io';

import 'package:file_errors/src/codes.dart';

import 'codes.dart';

bool _checkCode(FileSystemException exception, bool Function(int) check) {
  int? code = exception.osError?.errorCode;
  return (code!=null) && check(code);
}

bool isNoSuchPathException(FileSystemException exception) {
  return _checkCode(exception, isNoSuchPathCode);
}

bool isNoSuchDirectoryException(FileSystemException exception) {
  return _checkCode(exception, isNoSuchDirectoryCode);
}


bool isDirectoryNotEmptyException(FileSystemException exception) {
  return _checkCode(exception, isNotEmptyCode);
}

