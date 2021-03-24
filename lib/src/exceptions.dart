// SPDX-FileCopyrightText: (c) 2021 Art Galkin <github.com/rtmigo>
// SPDX-License-Identifier: UPL-1.0

import 'dart:io';

import 'package:file_errors/src/codes.dart';

import 'codes.dart';

bool isNoFileOrParentException(FileSystemException exception) {
  int? code = exception.osError?.errorCode;
  return (code!=null) ? isNoFileOrParentCode(code) : false;
}

bool isNoFileException(FileSystemException exception) {
  int? code = exception.osError?.errorCode;
  return (code!=null) ? isNoFileCode(code) : false;
}

bool isNoDirectoryException(FileSystemException exception) {
  int? code = exception.osError?.errorCode;
  return (code!=null) ? isNoDirectoryCode(code) : false;
}

bool isNotEmptyException(FileSystemException exception) {
  int? code = exception.osError?.errorCode;
  return (code!=null) ? isNotEmptyCode(code) : false;
}