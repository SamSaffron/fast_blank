### `String#blank?` Ruby Extension

[![Gem Version](https://badge.fury.io/rb/fast_blank.svg)](http://badge.fury.io/rb/fast_blank) [![Build Status](https://github.com/SamSaffron/fast_blank/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/SamSaffron/fast_blank/actions/workflows/test.yml)

`fast_blank` is a simple C extension which provides a fast implementation of [Active Support's `String#blank?` method](http://api.rubyonrails.org/classes/String.html#method-i-blank-3F).

### How do you use it?

    require 'fast_blank'

or add it to your Bundler Gemfile

    gem 'fast_blank'

### How fast is "Fast"?

About 1.2–20x faster than Active Support on my machine (your mileage my vary, depends on string length):

```
$ bundle exec ./benchmark

================== Test String Length: 0 ==================
Warming up --------------------------------------
          Fast Blank     2.811M i/100ms
  Fast ActiveSupport     2.775M i/100ms
          Slow Blank   319.479k i/100ms
      New Slow Blank     2.590M i/100ms
Calculating -------------------------------------
          Fast Blank     28.309M (± 0.7%) i/s -    143.355M in   5.064154s
  Fast ActiveSupport     27.885M (± 0.7%) i/s -    141.517M in   5.075252s
          Slow Blank      3.209M (± 1.0%) i/s -     16.293M in   5.077717s
      New Slow Blank     26.017M (± 0.9%) i/s -    132.115M in   5.078494s

Comparison:
          Fast Blank: 28309178.6 i/s
  Fast ActiveSupport: 27884928.2 i/s - 1.02x  slower
      New Slow Blank: 26016869.2 i/s - 1.09x  slower
          Slow Blank:  3209138.7 i/s - 8.82x  slower


================== Test String Length: 6 ==================
Warming up --------------------------------------
          Fast Blank     1.609M i/100ms
  Fast ActiveSupport     1.563M i/100ms
          Slow Blank   278.445k i/100ms
      New Slow Blank   848.522k i/100ms
Calculating -------------------------------------
          Fast Blank     15.916M (± 1.9%) i/s -     80.437M in   5.056039s
  Fast ActiveSupport     15.593M (± 1.9%) i/s -     78.128M in   5.012318s
          Slow Blank      2.894M (± 1.3%) i/s -     14.479M in   5.004609s
      New Slow Blank      8.521M (± 1.2%) i/s -     43.275M in   5.079181s

Comparison:
          Fast Blank: 15915513.5 i/s
  Fast ActiveSupport: 15592918.2 i/s - same-ish: difference falls within error
      New Slow Blank:  8521250.6 i/s - 1.87x  slower
          Slow Blank:  2893641.0 i/s - 5.50x  slower


================== Test String Length: 14 ==================
Warming up --------------------------------------
          Fast Blank     2.642M i/100ms
  Fast ActiveSupport     2.541M i/100ms
          Slow Blank   616.028k i/100ms
      New Slow Blank   943.087k i/100ms
Calculating -------------------------------------
          Fast Blank     26.282M (± 0.8%) i/s -    132.078M in   5.025646s
  Fast ActiveSupport     25.314M (± 1.2%) i/s -    127.038M in   5.019340s
          Slow Blank      6.094M (± 2.1%) i/s -     30.801M in   5.056336s
      New Slow Blank      9.414M (± 1.0%) i/s -     47.154M in   5.009560s

Comparison:
          Fast Blank: 26282498.1 i/s
  Fast ActiveSupport: 25313579.3 i/s - 1.04x  slower
      New Slow Blank:  9413905.4 i/s - 2.79x  slower
          Slow Blank:  6094343.2 i/s - 4.31x  slower


================== Test String Length: 24 ==================
Warming up --------------------------------------
          Fast Blank     1.945M i/100ms
  Fast ActiveSupport     1.899M i/100ms
          Slow Blank   550.633k i/100ms
      New Slow Blank   788.512k i/100ms
Calculating -------------------------------------
          Fast Blank     19.399M (± 1.0%) i/s -     97.259M in   5.014145s
  Fast ActiveSupport     18.903M (± 0.7%) i/s -     94.958M in   5.023799s
          Slow Blank      5.486M (± 1.0%) i/s -     27.532M in   5.019220s
      New Slow Blank      7.772M (± 1.3%) i/s -     39.426M in   5.073728s

Comparison:
          Fast Blank: 19399137.3 i/s
  Fast ActiveSupport: 18902692.5 i/s - 1.03x  slower
      New Slow Blank:  7771936.7 i/s - 2.50x  slower
          Slow Blank:  5485855.2 i/s - 3.54x  slower


================== Test String Length: 136 ==================
Warming up --------------------------------------
          Fast Blank     1.937M i/100ms
  Fast ActiveSupport     1.885M i/100ms
          Slow Blank   549.012k i/100ms
      New Slow Blank   790.087k i/100ms
Calculating -------------------------------------
          Fast Blank     19.401M (± 0.6%) i/s -     98.807M in   5.093149s
  Fast ActiveSupport     18.916M (± 1.0%) i/s -     96.139M in   5.082984s
          Slow Blank      5.491M (± 1.0%) i/s -     28.000M in   5.099366s
      New Slow Blank      7.864M (± 0.6%) i/s -     39.504M in   5.023416s

Comparison:
          Fast Blank: 19400820.9 i/s
  Fast ActiveSupport: 18915679.7 i/s - 1.03x  slower
      New Slow Blank:  7864288.1 i/s - 2.47x  slower
          Slow Blank:  5491367.9 i/s - 3.53x  slower
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

1.0.1:
  - Minor, avoid warnings if redefining blank?

1.0.0:
  - Adds Ruby 2.2 support ([@tjschuck](https://github.com/tjschuck) — [#9](https://github.com/SamSaffron/fast_blank/pull/9))

0.0.2:
  - Removed rake dependency ([@tmm1](https://github.com/tmm1) — [#2](https://github.com/SamSaffron/fast_blank/pull/2))
  - Unrolled internal loop to improve perf ([@tmm1](https://github.com/tmm1) — [#2](https://github.com/SamSaffron/fast_blank/pull/2))
