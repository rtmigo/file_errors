import 'dart:io';

import 'package:file_errors/file_errors.dart';

void main() {
  try {

    print(File('filename.txt').readAsStringSync());

  } on FileSystemException catch (exc) {

    if (isPathDoesNotExistException(exc)) {
      print('File does not exist!');
    }
    else {
      print('Unknown error: $exc');
    }
  }
}