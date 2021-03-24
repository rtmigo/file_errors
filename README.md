![Generic badge](https://img.shields.io/badge/status-draft-error.svg)
![Generic badge](https://img.shields.io/badge/testing_on-Win_|_Mac_|_Linux-blue.svg)


A couple of cross-platform functions to help identify common errors when 
working with the file system.

These functions interpret the 
[OSError.errorCode](https://api.dart.dev/stable/dart-io/OSError/errorCode.html) 
value depending on the current platform.

## isNoFileOrParent

When you try to open a non-existent file, or a file in a non-existent 
directory.
1
## isNoFile

When you try to open a non-existent file. 
  
## isNoDirectory

When you try to list the files in a directory that does not exist. 
On some operating systems, it also occurs when you try to open a file in a 
directory that does not exist.

## isNotEmpty

When you try to delete a directory but it contains files.