![Generic badge](https://img.shields.io/badge/status-draft-red.svg)
![Generic badge](https://img.shields.io/badge/testing_on-Win_|_Mac_|_Linux-blue.svg)


A couple of cross-platform functions to help identify common errors when 
working with the file system.

Some systems report missing file or missing parent directory as two different 
errors. Others report both problems with the same error code. In addition, 
the error codes on different systems are different.

This library is designed to summarize error codes, reducing them to a "common 
denominator". It interprets the [OSError.errorCode](https://api.dart.dev/stable/dart-io/OSError/errorCode.html) 
value depending on the current platform.

Functions tested on Linux, Windows and MacOS. Unit tests did not run on 
Android and iOS. But these mobile systems have the same kernels as desktop 
systems. So the error messages are almost certainly the same.


## isPathDoesNotExist

Occurs when:
- Trying to open a non-existent file in an existing directory
- Trying to open a file in a non-existent directory
- Trying to non-recursively create a file in a non-existent directory
- Trying to list a non-existent directory

``` dart
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
```

## isDirectoryNotEmpty

Occurs when you try to non-recursively delete a directory but it contains files.

``` dart
  try {
    
   Directory('/path/to/useless').deleteSync();
    
  } on FileSystemException catch (exc) {
    
    if (isDirectoryNotEmptyException(exc)) {
      print('File does not exist!');
    }
    else {
      print('Unknown error: $exc');
    }
  }
```