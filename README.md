### `String#blank?` Ruby Extension

[![Gem Version](https://badge.fury.io/rb/fast_blank.png)](http://badge.fury.io/rb/fast_blank) [![Build Status](https://travis-ci.org/SamSaffron/fast_blank.png?branch=master)](https://travis-ci.org/SamSaffron/fast_blank)

`fast_blank` is a simple C extension which provides a fast implementation of [Active Support's `String#blank?` method](http://api.rubyonrails.org/classes/String.html#method-i-blank-3F).

### How do you use it?

    require 'fast_blank'

### How fast is "Fast"?

About 6–20x faster than Active Support on my machine (your mileage my vary):

```
$ bundle exec ./benchmark

================== Test String Length: 0 ==================
Calculating -------------------------------------
          Fast Blank   130.949k i/100ms
  Fast ActiveSupport   129.356k i/100ms
          Slow Blank    56.008k i/100ms
-------------------------------------------------
          Fast Blank     21.520M (±10.4%) i/s -    105.938M
  Fast ActiveSupport     21.347M (± 9.5%) i/s -    105.425M
          Slow Blank      1.106M (±30.1%) i/s -      4.929M

Comparison:
          Fast Blank: 21520211.2 i/s
  Fast ActiveSupport: 21347192.0 i/s - 1.01x slower
          Slow Blank:  1105743.4 i/s - 19.46x slower


================== Test String Length: 6 ==================
Calculating -------------------------------------
          Fast Blank   121.226k i/100ms
  Fast ActiveSupport   121.165k i/100ms
          Slow Blank    50.455k i/100ms
-------------------------------------------------
          Fast Blank      9.595M (± 9.8%) i/s -     47.399M
  Fast ActiveSupport     10.583M (± 8.5%) i/s -     52.464M
          Slow Blank    964.469k (±27.6%) i/s -      4.390M

Comparison:
  Fast ActiveSupport: 10583227.9 i/s
          Fast Blank:  9594957.8 i/s - 1.10x slower
          Slow Blank:   964468.9 i/s - 10.97x slower


================== Test String Length: 14 ==================
Calculating -------------------------------------
          Fast Blank   129.496k i/100ms
  Fast ActiveSupport   129.604k i/100ms
          Slow Blank    83.756k i/100ms
-------------------------------------------------
          Fast Blank     17.970M (± 9.3%) i/s -     88.834M
  Fast ActiveSupport     18.181M (± 9.3%) i/s -     89.816M
          Slow Blank      2.428M (± 6.8%) i/s -     12.145M

Comparison:
  Fast ActiveSupport: 18180635.5 i/s
          Fast Blank: 17969809.8 i/s - 1.01x slower
          Slow Blank:  2428259.9 i/s - 7.49x slower


================== Test String Length: 24 ==================
Calculating -------------------------------------
          Fast Blank   122.337k i/100ms
  Fast ActiveSupport   126.468k i/100ms
          Slow Blank    76.495k i/100ms
-------------------------------------------------
          Fast Blank     11.960M (± 9.4%) i/s -     59.211M
  Fast ActiveSupport     12.421M (± 9.6%) i/s -     61.337M
          Slow Blank      2.104M (± 8.0%) i/s -     10.480M

Comparison:
  Fast ActiveSupport: 12421448.7 i/s
          Fast Blank: 11959811.7 i/s - 1.04x slower
          Slow Blank:  2103905.1 i/s - 5.90x slower


================== Test String Length: 136 ==================
Calculating -------------------------------------
          Fast Blank   123.617k i/100ms
  Fast ActiveSupport   123.682k i/100ms
          Slow Blank    76.362k i/100ms
-------------------------------------------------
          Fast Blank     11.952M (±11.5%) i/s -     58.594M
  Fast ActiveSupport     12.520M (± 9.0%) i/s -     61.965M
          Slow Blank      2.112M (± 6.9%) i/s -     10.538M

Comparison:
  Fast ActiveSupport: 12520143.0 i/s
          Fast Blank: 11952169.1 i/s - 1.05x slower
          Slow Blank:  2112055.6 i/s - 5.93x slower
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
