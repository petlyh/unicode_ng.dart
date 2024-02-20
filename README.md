# unicode_ng

Unicode characters library auto generated from http://www.unicode.org.

Unicode Version 15.0.0

## Add to project

```sh
$ dart pub add unicode_ng --git-url=https://github.com/petlyh/unicode_ng.dart --git-ref=v0.1.0
```

## Regenerate Library

```sh
$ dart run generate/main.dart lib/src/unicode.g.dart
```

## Origin

This package is based on the [`unicode`](https://pub.dev/packages/unicode) package by [Andrew Mezoni](https://github.com/mezoni) and has been modified to support Dart 3+.

Changes from `unicode` package:

- Supports Dart 3+ with null safety
- Uses `code_builder` for generation instead of string templating with `template_block`
- Generated from newer Unicode standard (15.0.0 as of writing)
- Unmaintaned `lists` library is bundled instead of depended on

## License

The original license is reproduced below and in the `LICENSE.txt` file:

```
Copyright (c) 2014, Andrew Mezoni
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the Andrew Mezoni nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```