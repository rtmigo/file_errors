![Generic badge](https://img.shields.io/badge/status-draft-red.svg)
![Generic badge](https://img.shields.io/badge/testing_on-Win_|_Mac_|_Linux-blue.svg)


A couple of **cross-platform** functions to help identify common errors when 
working with the file system.


<details>
    <summary>Whats the problem?</summary>
Some OSs report missing file or missing parent directory as two different 
errors. Others report both problems as the same error. Dart throws the same 
type of exception not only for these two errors, but also for any file errors. 
You can try to analyze the `int` error code, but error codes on different 
systems are different.

How, then, to understand that the exception was thrown due to the absence of a file?
</details>

This library is designed to generalize error codes, reducing them to a "common 
denominator". It interprets the [OSError.errorCode](https://api.dart.dev/stable/dart-io/OSError/errorCode.html) 
value depending on the current platform.

Functions unit-tested on **Linux**, **Windows** and **MacOS**. Mobile systems 
such as **Android** and **iOS** have the same kernels as their desktop 
relatives. So the error messages are almost certainly the same.


## isNoSuchPath

Occurs when:
- Trying to open a non-existent file in an existing directory
- Trying to open a file in a non-existent directory
- Trying to non-recursively create a file in a non-existent directory
- Trying to list a non-existent directory

``` dart
  try {
    
    print(File('filename.txt').readAsStringSync());
    
  } on FileSystemException catch (exc) {
    
    if (isNoSuchPathException(exc)) {
      print('File does not exist!');
    }
    else {
      print('Unknown error: $exc');
    }
  }
```

There is also a `isNoSuchPathCode(int errorCode)` function, if you want to 
interpret `OSError.errorCode` yourself.

## isDirectoryNotEmpty

Occurs when you try to non-recursively delete a directory but it contains files.

``` dart
  try {
    
   Directory('/path/to/useless').deleteSync();
    
  } on FileSystemException catch (exc) {
    
    if (isDirectoryNotEmptyException(exc)) {
      print('Not empty!');
    }
    else {
      print('Unknown error: $exc');
    }
  }
```

Also available as `isDirectoryNotEmptyCode(int errorCode)`.