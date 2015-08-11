### `String#blank?` Ruby Extension

[![Gem Version](https://badge.fury.io/rb/fast_blank.png)](http://badge.fury.io/rb/fast_blank) [![Build Status](https://travis-ci.org/SamSaffron/fast_blank.png?branch=master)](https://travis-ci.org/SamSaffron/fast_blank)

`fast_blank` is a simple C extension which provides a fast implementation of [Active Support's `String#blank?` method](http://api.rubyonrails.org/classes/String.html#method-i-blank-3F).

### How do you use it?

    require 'fast_blank'

### How fast is "Fast"?

About 3.5–8x faster than Active Support on my machine (your mileage my vary):

    $ ./benchmark

```
                                            user     system      total        real
Fast Blank 0    :                       0.080000   0.000000   0.080000 (  0.084032)
Fast Blank (Active Support)  0    :     0.080000   0.000000   0.080000 (  0.083599)
Slow Blank 0    :                       0.930000   0.050000   0.980000 (  0.986029)
Fast Blank 6    :                       0.150000   0.000000   0.150000 (  0.156408)
Fast Blank (Active Support)  6    :     0.130000   0.000000   0.130000 (  0.123618)
Slow Blank 6    :                       1.080000   0.050000   1.130000 (  1.133616)
Fast Blank 14    :                      0.090000   0.000000   0.090000 (  0.090577)
Fast Blank (Active Support)  14    :    0.090000   0.000000   0.090000 (  0.096469)
Slow Blank 14    :                      0.500000   0.000000   0.500000 (  0.501756)
Fast Blank 24    :                      0.130000   0.000000   0.130000 (  0.124822)
Fast Blank (Active Support)  24    :    0.110000   0.000000   0.110000 (  0.116654)
Slow Blank 24    :                      0.560000   0.000000   0.560000 (  0.556493)
Fast Blank 136    :                     0.130000   0.000000   0.130000 (  0.129399)
Fast Blank (Active Support)  136    :   0.120000   0.000000   0.120000 (  0.120694)
Slow Blank 136    :                     0.540000   0.000000   0.540000 (  0.545197)
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
