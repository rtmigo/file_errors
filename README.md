![Generic badge](https://img.shields.io/badge/status-draft-error.svg)
![Generic badge](https://img.shields.io/badge/testing_on-Win_|_Mac_|_Linux-blue.svg)


A couple of cross-platform functions to help identify common errors when 
working with the file system.

These functions interpret the 
[OSError.errorCode](https://api.dart.dev/stable/dart-io/OSError/errorCode.html) 
value depending on the current platform.

## isPathDoesNotExist

Occurs when:
- Trying to open a non-existent file in an existing directory
- Trying to open a file in a non-existent directory
- Trying to create a file in a non-existent directory
- Trying to list a non-existent directory

## isNotEmpty

Occurs when you try to delete a directory but it contains files.