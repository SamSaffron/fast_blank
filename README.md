### `String#blank?` Ruby Extension

[![Gem Version](https://badge.fury.io/rb/fast_blank.svg)](http://badge.fury.io/rb/fast_blank) [![Build Status](https://github.com/SamSaffron/fast_blank/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/SamSaffron/fast_blank/actions/workflows/test.yml)

`fast_blank` is a simple C extension which provides a fast implementation of [Active Support's `String#blank?` method](http://api.rubyonrails.org/classes/String.html#method-i-blank-3F).

### How do you use it?

    require 'fast_blank'

or add it to your Bundler Gemfile

    gem 'fast_blank'

`fast_blank` must be loaded **after** Active Support: `require 'active_support/core_ext/object/blank'` defines its own `String#blank?` and silently replaces the one from `fast_blank` if it comes second.

### How fast is "Fast"?

Speed relative to Active Support 8.1.4's `String#blank?` (above 1x is faster):

| String | MRI `blank?` | MRI `blank_as?` | JRuby `blank?` | JRuby `blank_as?` | TruffleRuby `blank?` | TruffleRuby `blank_as?` |
|---|---|---|---|---|---|---|
| `""` | 1.08x | 1.07x | 1.07x | 1.01x | 1.05x | 1.02x |
| 6 blanks | 3.00x | 3.00x | 1.51x | 1.54x | 0.93x | 0.99x |
| 14 chars of text | 3.31x | 3.31x | 1.51x | 1.40x | 1.06x | 0.98x |
| 24 chars, leading blanks | 3.84x | 3.80x | 1.63x | 1.58x | 1.11x | 0.97x |
| 136 chars, multi-line text | 3.80x | 3.82x | 1.66x | 1.62x | 1.11x | 0.97x |
| 136 spaces | 5.29x | 6.34x | 6.32x | 5.75x | 0.87x | 1.00x |
| Unicode blanks | 3.29x | 2.19x | 1.56x | 1.32x | 2.01x | 0.99x |
| Unicode text | 3.04x | 2.98x | 1.40x | 1.49x | 1.11x | 0.98x |

Measured on arm64 macOS with MRI 4.0.7, JRuby 10.1.2.0 (OpenJDK 25.0.2) and TruffleRuby 40.0.0, one process per method and string, each calling the method directly on 64 distinct copies of the string so that no JIT can fold the call. On TruffleRuby `fast_blank` uses plain Ruby (see the compatibility note), hence on-par results.

Memory: neither `fast_blank` nor Active Support 8.1.4 allocates on MRI (0 objects per 100,000 calls). On JRuby `fast_blank` allocates nothing, while Active Support allocates about 208 bytes per call, and about 4 KB per call on a string of 136 spaces.

To reproduce the table on your machine (it prints one engine's columns):

    bundle config set --local with bench   # installs Active Support, an optional group
    bundle install
    bundle exec rake bench:activesupport

`bundle exec rake bench` compiles the extension and runs `./benchmark`, which checks `blank?` and `blank_as?` against two regexp-based implementations.

### Compatibility note:

CI runs the test suite on MRI 2.0 to 4.0, JRuby and TruffleRuby.

* **MRI** uses the C extension.
* **JRuby** uses the Java extension shipped as `lib/fast_blank.jar`. It is compiled to Java 8 bytecode so that the same jar also loads on JRuby 9.4.
* **TruffleRuby** neither builds nor loads the C extension: TruffleRuby runs C extensions through an emulation layer that made both methods slower than Active Support, so they are implemented in Ruby there, with the same semantics.

`fast_blank` implements `String#blank?` as MRI would have implemented it, meaning it has 100% parity with `String#strip.length == 0`.

Active Support's version also considers Unicode spaces.  For example, `"\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000".blank?` is true in Active Support even though `fast_blank` would treat it as *not* blank.  Therefore, `fast_blank` also provides `blank_as?` which is a 100%-compatible Active Support `blank?` replacement.

### Credits

* Author: Sam Saffron (sam.saffron@gmail.com)
* https://github.com/SamSaffron/fast_blank
* License: MIT
* Gem template based on [CodeMonkeySteve/fast_xor](https://github.com/CodeMonkeySteve/fast_xor)

### Change log:

Unreleased:
  - Fix `blank_as?` in non-Unicode encodings (Windows-1252, ISO-8859-*, binary…), where bytes such as `0x85` and `0xA0` were compared to Unicode code points and visible characters were reported as blank
  - JRuby: 7-bit fast path for `blank_as?` too (it was already there for `blank?`), also taken when the code range has not been computed yet
  - 7-bit fast path in the C extension (`blank?` and `blank_as?`)
  - Pure-Ruby implementation on TruffleRuby instead of the C extension, which is no longer built there
  - The C extension can be used from non-main Ractors

1.0.1:
  - Minor, avoid warnings if redefining blank?

1.0.0:
  - Adds Ruby 2.2 support ([@tjschuck](https://github.com/tjschuck) — [#9](https://github.com/SamSaffron/fast_blank/pull/9))

0.0.2:
  - Removed rake dependency ([@tmm1](https://github.com/tmm1) — [#2](https://github.com/SamSaffron/fast_blank/pull/2))
  - Unrolled internal loop to improve perf ([@tmm1](https://github.com/tmm1) — [#2](https://github.com/SamSaffron/fast_blank/pull/2))
