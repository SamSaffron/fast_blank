### `String#blank?` Ruby Extension

[![Gem Version](https://badge.fury.io/rb/fast_blank.png)](http://badge.fury.io/rb/fast_blank) [![Build Status](https://travis-ci.org/SamSaffron/fast_blank.png?branch=master)](https://travis-ci.org/SamSaffron/fast_blank)

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
Calculating -------------------------------------
          Fast Blank   175.955k i/100ms
  Fast ActiveSupport   177.386k i/100ms
          Slow Blank    84.206k i/100ms
      New Slow Blank   173.732k i/100ms
-------------------------------------------------
          Fast Blank     26.134M (± 6.1%) i/s -    129.855M
  Fast ActiveSupport     25.632M (±10.0%) i/s -    125.767M
          Slow Blank      1.633M (± 6.6%) i/s -      8.168M
      New Slow Blank     19.162M (±11.6%) i/s -     94.336M

Comparison:
          Fast Blank: 26134380.9 i/s
  Fast ActiveSupport: 25632474.8 i/s - 1.02x slower
      New Slow Blank: 19162018.3 i/s - 1.36x slower
          Slow Blank:  1632519.4 i/s - 16.01x slower


================== Test String Length: 6 ==================
Calculating -------------------------------------
          Fast Blank   126.348k i/100ms
  Fast ActiveSupport   148.406k i/100ms
          Slow Blank    64.285k i/100ms
      New Slow Blank    93.053k i/100ms
-------------------------------------------------
          Fast Blank      9.335M (± 6.6%) i/s -     46.370M
  Fast ActiveSupport     10.306M (± 4.3%) i/s -     51.497M
          Slow Blank      1.428M (± 6.9%) i/s -      7.136M
      New Slow Blank      2.153M (± 3.8%) i/s -     10.794M

Comparison:
  Fast ActiveSupport: 10305820.1 i/s
          Fast Blank:  9334875.2 i/s - 1.10x slower
      New Slow Blank:  2153314.6 i/s - 4.79x slower
          Slow Blank:  1428318.5 i/s - 7.22x slower


================== Test String Length: 14 ==================
Calculating -------------------------------------
          Fast Blank   171.908k i/100ms
  Fast ActiveSupport   171.954k i/100ms
          Slow Blank   111.441k i/100ms
      New Slow Blank    82.109k i/100ms
-------------------------------------------------
          Fast Blank     17.847M (±12.4%) i/s -     87.673M
  Fast ActiveSupport     19.275M (± 8.5%) i/s -     95.434M
          Slow Blank      3.201M (± 5.0%) i/s -     16.048M
      New Slow Blank      1.610M (± 5.9%) i/s -      8.047M

Comparison:
  Fast ActiveSupport: 19275233.9 i/s
          Fast Blank: 17847351.8 i/s - 1.08x slower
          Slow Blank:  3201263.8 i/s - 6.02x slower
      New Slow Blank:  1610193.5 i/s - 11.97x slower


================== Test String Length: 24 ==================
Calculating -------------------------------------
          Fast Blank   161.284k i/100ms
  Fast ActiveSupport   156.552k i/100ms
          Slow Blank   107.136k i/100ms
      New Slow Blank    75.888k i/100ms
-------------------------------------------------
          Fast Blank     11.639M (± 7.0%) i/s -     57.740M
  Fast ActiveSupport     11.571M (±10.8%) i/s -     56.985M
          Slow Blank      2.772M (± 5.5%) i/s -     13.821M
      New Slow Blank      1.489M (± 5.3%) i/s -      7.437M

Comparison:
          Fast Blank: 11638605.2 i/s
  Fast ActiveSupport: 11571159.9 i/s - 1.01x slower
          Slow Blank:  2771977.6 i/s - 4.20x slower
      New Slow Blank:  1488644.4 i/s - 7.82x slower


================== Test String Length: 136 ==================
Calculating -------------------------------------
          Fast Blank   159.586k i/100ms
  Fast ActiveSupport   160.982k i/100ms
          Slow Blank   106.354k i/100ms
      New Slow Blank    77.455k i/100ms
-------------------------------------------------
          Fast Blank     11.774M (± 5.9%) i/s -     58.568M
  Fast ActiveSupport     11.237M (±12.9%) i/s -     55.056M
          Slow Blank      2.546M (±13.4%) i/s -     12.550M
      New Slow Blank      1.282M (±16.4%) i/s -      6.274M

Comparison:
          Fast Blank: 11773722.8 i/s
  Fast ActiveSupport: 11237239.4 i/s - 1.05x slower
          Slow Blank:  2545953.1 i/s - 4.62x slower
      New Slow Blank:  1282478.2 i/s - 9.18x slower
```

If you have Crystal installed, it will automatically compile the Crystal version. And this is the same benchmark of Ruby compared to Crystal:

TODO: the Crystal version is actually slowing down instead. Need investigation.

```
================== Test String Length: 0 ==================
Calculating -------------------------------------
          Fast Blank   130.848k i/100ms
  Fast ActiveSupport   137.333k i/100ms
          Slow Blank    83.552k i/100ms
      New Slow Blank   172.358k i/100ms
-------------------------------------------------
          Fast Blank      7.857M (± 9.7%) i/s -     38.731M
  Fast ActiveSupport      7.746M (±12.5%) i/s -     37.904M
          Slow Blank      1.472M (±14.7%) i/s -      7.185M
      New Slow Blank     17.987M (±16.9%) i/s -     86.524M

Comparison:
      New Slow Blank: 17987192.9 i/s
          Fast Blank:  7856517.6 i/s - 2.29x slower
  Fast ActiveSupport:  7746000.4 i/s - 2.32x slower
          Slow Blank:  1471995.7 i/s - 12.22x slower


================== Test String Length: 6 ==================
Calculating -------------------------------------
          Fast Blank    86.678k i/100ms
  Fast ActiveSupport    79.319k i/100ms
          Slow Blank    65.693k i/100ms
      New Slow Blank    70.350k i/100ms
-------------------------------------------------
          Fast Blank      2.023M (±15.0%) i/s -      9.881M
  Fast ActiveSupport      2.308M (±18.9%) i/s -     11.105M
          Slow Blank      1.088M (±19.3%) i/s -      5.255M
      New Slow Blank      1.625M (±23.1%) i/s -      7.598M

Comparison:
  Fast ActiveSupport:  2308215.1 i/s
          Fast Blank:  2023149.3 i/s - 1.14x slower
      New Slow Blank:  1624922.4 i/s - 1.42x slower
          Slow Blank:  1088234.4 i/s - 2.12x slower


================== Test String Length: 14 ==================
Calculating -------------------------------------
          Fast Blank    74.098k i/100ms
  Fast ActiveSupport    67.948k i/100ms
          Slow Blank    73.262k i/100ms
      New Slow Blank    61.959k i/100ms
-------------------------------------------------
          Fast Blank      3.374M (±13.8%) i/s -     16.450M
  Fast ActiveSupport      2.692M (± 9.9%) i/s -     13.318M
          Slow Blank      3.146M (± 8.7%) i/s -     15.532M
      New Slow Blank      1.623M (± 6.1%) i/s -      8.117M

Comparison:
          Fast Blank:  3373729.1 i/s
          Slow Blank:  3145984.1 i/s - 1.07x slower
  Fast ActiveSupport:  2692438.7 i/s - 1.25x slower
      New Slow Blank:  1623077.0 i/s - 2.08x slower


================== Test String Length: 24 ==================
Calculating -------------------------------------
          Fast Blank    91.982k i/100ms
  Fast ActiveSupport    92.785k i/100ms
          Slow Blank    89.864k i/100ms
      New Slow Blank    67.668k i/100ms
-------------------------------------------------
          Fast Blank      1.926M (±10.4%) i/s -      9.566M
  Fast ActiveSupport      2.229M (± 6.4%) i/s -     11.134M
          Slow Blank      2.761M (± 6.1%) i/s -     13.749M
      New Slow Blank      1.488M (± 6.8%) i/s -      7.443M

Comparison:
          Slow Blank:  2761086.7 i/s
  Fast ActiveSupport:  2229438.7 i/s - 1.24x slower
          Fast Blank:  1926024.9 i/s - 1.43x slower
      New Slow Blank:  1488038.2 i/s - 1.86x slower


================== Test String Length: 136 ==================
Calculating -------------------------------------
          Fast Blank    50.628k i/100ms
  Fast ActiveSupport    51.896k i/100ms
          Slow Blank   105.472k i/100ms
      New Slow Blank    80.191k i/100ms
-------------------------------------------------
          Fast Blank    777.116k (± 5.0%) i/s -      3.898M
  Fast ActiveSupport    793.106k (± 7.5%) i/s -      3.944M
          Slow Blank      2.535M (±14.1%) i/s -     12.340M
      New Slow Blank      1.372M (±10.6%) i/s -      6.816M

Comparison:
          Slow Blank:  2534870.9 i/s
      New Slow Blank:  1372307.8 i/s - 1.85x slower
  Fast ActiveSupport:   793105.8 i/s - 3.20x slower
          Fast Blank:   777116.2 i/s - 3.26x slower
```

Additionally, this gem allocates no strings during the test, making it less of a GC burden.

### Compatibility note:

`fast_blank` supports MRI Ruby 1.9.3, 2.0, 2.1, and 2.2, as well as Rubinius 2.x. Earlier versions of MRI are untested.

`fast_blank` implements `String#blank?` as MRI would have implemented it, meaning it has 100% parity with `String#strip.length == 0`.

Active Support's version also considers Unicode spaces.  For example, `"\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000".blank?` is true in Active Support even though `fast_blank` would treat it as *not* blank.  Therefore, `fast_blank` also provides `blank_as?` which is a 100%-compatible Active Support `blank?` replacement.

The Crystal version does the same thing but still breaks a few specs on unicode. It should work just fine but for edge cases.

### Credits

* Author: Sam Saffron (sam.saffron@gmail.com)
* https://github.com/SamSaffron/fast_blank
* License: MIT
* Gem template based on [CodeMonkeySteve/fast_xor](https://github.com/CodeMonkeySteve/fast_xor)

### Change log:

1.1.0:
  - Adds the Crystal version and conditional extconf.rb to generate either the C or the Crystal versions of the makefile

1.0.0:
  - Adds Ruby 2.2 support ([@tjschuck](https://github.com/tjschuck) — [#9](https://github.com/SamSaffron/fast_blank/pull/9))

0.0.2:
  - Removed rake dependency ([@tmm1](https://github.com/tmm1) — [#2](https://github.com/SamSaffron/fast_blank/pull/2))
  - Unrolled internal loop to improve perf ([@tmm1](https://github.com/tmm1) — [#2](https://github.com/SamSaffron/fast_blank/pull/2))
