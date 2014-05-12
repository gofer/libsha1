# SHA1 Hash Library for C++

## What's this
This is SHA1 hash library for C++.

## Attention
This code uses C++11 features.

## How to use

### With pointer
SHA1 hasing function is in namespace SHA1. This function always return 0.

    int SHA1::hash(const std::string* src, SHA1::Hash* hash);
	
If you need convert Hash to std::string, you should use SAH1::to_string function. This function always return 0.

    int SHA1::to_string(const SHA1::Hash* hash, std::string* dst);

#### Attention!
If you use SHA1::to_string function with pointer, hash and dst arguments MUST be initialized and destroy.
You need initialized or destroy Hash type args, you MUST use by new/delete operator.
(Do NOT use ::malloc/::free functions.)

### With reference
SHA1 hasing function is in namespace SHA1.

	SHA1::Hash SHA1::hash(const std::string& src);

If you need convert Hash to std::string, you should use SHA1::to_string function.

    std::string to_string(const SHA1::Hash& hash);

## How to Build This Library

    $ ./configure
	$ ./make.sh all    # Attention: this is NOT typical "make" command.
	$ ./make.sh check  # You had better to confirm that all tests are passed.

### Example - sha1sum
This code is an imitation of "sha1sum" command.
(This program is only file input with text mode.)

    g++ -std=c++11 sha1sum.cpp -lsha1 -o sha1sum

This example code in "misc" directory.
If you try to compile "sha1sum.cpp", you should use "compile.sh".
(Take care of include and library path with -I and -L options.)

## Licence
This codes are licensed by New BSD License.
