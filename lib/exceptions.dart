import 'dart:io';

import 'package:file_errors/codes.dart';

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