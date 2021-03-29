// SPDX-FileCopyrightText: (c) 2021 Artёm I.G. <github.com/rtmigo>
// SPDX-License-Identifier: MIT


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

  /// Returns [true] if the exception was caused by error with code [errorCode] on Windows.
  bool isWindowsError(int errorCode) => Platform.isWindows && errorCode == this.osError?.errorCode;

  /// Returns [true] if the exception was caused by error with code [errorCode] on Linux.
  bool isLinuxError(int errorCode) => Platform.isLinux && errorCode == this.osError?.errorCode;

  /// Returns [true] if the exception was caused by error with code [errorCode] on macOS.
  bool isMacOsError(int errorCode) => Platform.isMacOS && errorCode == this.osError?.errorCode;

  /// Returns [true] if the exception was caused by error with code [errorCode] on iOS.
  bool isIosError(int errorCode) => Platform.isIOS && errorCode == this.osError?.errorCode;

  /// Returns [true] if the exception was caused by error with code [errorCode] on Android.
  bool isAndroidError(int errorCode) => Platform.isAndroid && errorCode == this.osError?.errorCode;

  /// Returns [true] if the exception was caused by error with code [errorCode] on Fuchsia.
  bool isFuchsiaError(int errorCode) => Platform.isFuchsia && errorCode == this.osError?.errorCode;
}

