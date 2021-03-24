![Generic badge](https://img.shields.io/badge/status-draft-red.svg)
![Generic badge](https://img.shields.io/badge/testing_on-Win_|_Mac_|_Linux-blue.svg)


**Cross-platform** extensions to help **identify** the **reason** for the 
**`FileSystemException`** to occur during file operations.

Extensions were unit-tested on **Linux**, **Windows** and **MacOS**. 
Mobile systems such as **Android** and **iOS** have the same kernels 
as their desktop relatives. So the error messages are almost certainly 
the same.


## isNoSuchFileOrDirectory

Occurs when:
- Trying to read a non-existent file in an existing directory
- Trying to read or write a file in a non-existent directory
- Trying to non-recursively create a file in a non-existent directory
- Trying to list a non-existent directory

``` dart
  try {
    
    print(File('filename.txt').readAsStringSync());
    
  } on FileSystemException catch (exc) {
    
    // using property extension added by the library
    if (exc.isNoSuchFileOrDirectory) { 
      print('It does not exist!');
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
    
    // using property extension added by the library
    if (exc.isDirectoryNotEmpty) {
      print('It is not empty!');
    }
    else {
      print('Unknown error: $exc');
    }
  }
```