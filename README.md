### `String#blank?` Ruby Extension

[![Gem Version](https://badge.fury.io/rb/fast_blank.png)](http://badge.fury.io/rb/fast_blank) [![Build Status](https://travis-ci.org/SamSaffron/fast_blank.png?branch=master)](https://travis-ci.org/SamSaffron/fast_blank)

`fast_blank` is a simple C extension which provides a fast implementation of [Active Support's `String#blank?` method](http://api.rubyonrails.org/classes/String.html#method-i-blank-3F).

### How do you use it?

    require 'fast_blank'

### How fast is "Fast"?

About 3.5–8x faster than Active Support on my machine (your mileage my vary):

```
$ bundle exec ./benchmark

================== Test String Length: 0 ==================
Calculating -------------------------------------
          Fast Blank   112.678k i/100ms
  Fast ActiveSupport   120.580k i/100ms
          Slow Blank    49.168k i/100ms
-------------------------------------------------
          Fast Blank      6.695M (±15.2%) i/s -     32.677M
  Fast ActiveSupport      6.760M (±15.1%) i/s -     33.039M
          Slow Blank    856.495k (±28.3%) i/s -      3.884M

Comparison:
  Fast ActiveSupport:  6760238.6 i/s
          Fast Blank:  6694767.8 i/s - 1.01x slower
          Slow Blank:   856494.6 i/s - 7.89x slower


================== Test String Length: 6 ==================
Calculating -------------------------------------
          Fast Blank   108.887k i/100ms
  Fast ActiveSupport   108.098k i/100ms
          Slow Blank    45.443k i/100ms
-------------------------------------------------
          Fast Blank      4.305M (±19.8%) i/s -     20.253M
  Fast ActiveSupport      5.225M (±12.0%) i/s -     25.727M
          Slow Blank    827.722k (±26.3%) i/s -      3.817M

Comparison:
  Fast ActiveSupport:  5225360.3 i/s
          Fast Blank:  4304868.6 i/s - 1.21x slower
          Slow Blank:   827721.6 i/s - 6.31x slower


================== Test String Length: 14 ==================
Calculating -------------------------------------
          Fast Blank   127.247k i/100ms
  Fast ActiveSupport   127.443k i/100ms
          Slow Blank    78.641k i/100ms
-------------------------------------------------
          Fast Blank      6.704M (±11.4%) i/s -     33.084M
  Fast ActiveSupport      6.811M (±10.9%) i/s -     33.645M
          Slow Blank      1.789M (± 8.4%) i/s -      8.965M

Comparison:
  Fast ActiveSupport:  6811231.1 i/s
          Fast Blank:  6704016.0 i/s - 1.02x slower
          Slow Blank:  1788751.1 i/s - 3.81x slower


================== Test String Length: 24 ==================
Calculating -------------------------------------
          Fast Blank   121.925k i/100ms
  Fast ActiveSupport   121.461k i/100ms
          Slow Blank    73.723k i/100ms
-------------------------------------------------
          Fast Blank      5.399M (±12.5%) i/s -     26.580M
  Fast ActiveSupport      5.584M (±11.7%) i/s -     27.572M
          Slow Blank      1.563M (± 8.4%) i/s -      7.815M

Comparison:
  Fast ActiveSupport:  5584121.3 i/s
          Fast Blank:  5398896.6 i/s - 1.03x slower
          Slow Blank:  1562511.2 i/s - 3.57x slower


================== Test String Length: 136 ==================
Calculating -------------------------------------
          Fast Blank   120.336k i/100ms
  Fast ActiveSupport   124.404k i/100ms
          Slow Blank    75.506k i/100ms
-------------------------------------------------
          Fast Blank      5.536M (±11.2%) i/s -     27.316M
  Fast ActiveSupport      5.622M (±12.0%) i/s -     27.742M
          Slow Blank      1.582M (± 7.6%) i/s -      7.928M

Comparison:
  Fast ActiveSupport:  5622323.3 i/s
          Fast Blank:  5535617.1 i/s - 1.02x slower
          Slow Blank:  1582003.7 i/s - 3.55x slower
```

Additionally, this gem allocates no strings during the test, making it less of a GC burden.

### Compatibility note:

`fast_blank` supports MRI Ruby 1.9.3, 2.0, 2.1, and 2.2, as well as Rubinius 2.x. Earlier versions of MRI are untested.

`fast_blank` implements `String#blank?` as MRI would have implemented it, meaning it has 100% parity with `String#strip.length == 0`.

Active Support's version also considers Unicode spaces.  For example, `"\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000".blank?` is true in Active Support even though `fast_blank` would treat it as *not* blank.  Therefore, `fast_blank` also provides `blank_as?` which is a 100%-compatible Active Support `blank?` replacement.

### Credits

* Author: Sam Saffron (sam.saffron@gmail.com)
* https://github.com/SamSaffron/fast_blank
* License: MIT
* Gem template based on [CodeMonkeySteve/fast_xor](https://github.com/CodeMonkeySteve/fast_xor)

### Change log:

1.0.0:
  - Adds Ruby 2.2 support ([@tjschuck](https://github.com/tjschuck) — [#9](https://github.com/SamSaffron/fast_blank/pull/9))

0.0.2:
  - Removed rake dependency ([@tmm1](https://github.com/tmm1) — [#2](https://github.com/SamSaffron/fast_blank/pull/2))
  - Unrolled internal loop to improve perf ([@tmm1](https://github.com/tmm1) — [#2](https://github.com/SamSaffron/fast_blank/pull/2))
