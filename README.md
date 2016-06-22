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

```
================== Test String Length: 0 ==================
Calculating -------------------------------------
          Fast Blank    93.058k i/100ms
  Fast ActiveSupport    90.831k i/100ms
          Slow Blank    85.016k i/100ms
      New Slow Blank   172.320k i/100ms
-------------------------------------------------
          Fast Blank      2.338M (± 8.0%) i/s -     11.632M
  Fast ActiveSupport      2.218M (±16.6%) i/s -     10.718M
          Slow Blank      1.559M (± 9.6%) i/s -      7.736M
      New Slow Blank     18.679M (±17.5%) i/s -     89.089M

Comparison:
      New Slow Blank: 18678711.7 i/s
          Fast Blank:  2338327.0 i/s - 7.99x slower
  Fast ActiveSupport:  2218331.7 i/s - 8.42x slower
          Slow Blank:  1558660.2 i/s - 11.98x slower


================== Test String Length: 6 ==================
Calculating -------------------------------------
          Fast Blank    72.629k i/100ms
  Fast ActiveSupport    84.776k i/100ms
          Slow Blank    62.860k i/100ms
      New Slow Blank    79.570k i/100ms
-------------------------------------------------
          Fast Blank      1.831M (±13.5%) i/s -      9.006M
  Fast ActiveSupport      2.033M (± 7.4%) i/s -     10.173M
          Slow Blank      1.444M (± 4.6%) i/s -      7.229M
      New Slow Blank      2.150M (± 4.4%) i/s -     10.742M

Comparison:
      New Slow Blank:  2150109.6 i/s
  Fast ActiveSupport:  2032594.7 i/s - 1.06x slower
          Fast Blank:  1831031.2 i/s - 1.17x slower
          Slow Blank:  1444152.9 i/s - 1.49x slower


================== Test String Length: 14 ==================
Calculating -------------------------------------
          Fast Blank   103.028k i/100ms
  Fast ActiveSupport   104.600k i/100ms
          Slow Blank   117.672k i/100ms
      New Slow Blank    83.105k i/100ms
-------------------------------------------------
          Fast Blank      2.909M (± 9.8%) i/s -     14.424M
  Fast ActiveSupport      3.004M (± 8.0%) i/s -     14.958M
          Slow Blank      3.241M (± 4.1%) i/s -     16.239M
      New Slow Blank      1.624M (± 5.5%) i/s -      8.144M

Comparison:
          Slow Blank:  3241261.2 i/s
  Fast ActiveSupport:  3003942.4 i/s - 1.08x slower
          Fast Blank:  2908911.0 i/s - 1.11x slower
      New Slow Blank:  1624285.3 i/s - 2.00x slower


================== Test String Length: 24 ==================
Calculating -------------------------------------
          Fast Blank    97.126k i/100ms
  Fast ActiveSupport    96.868k i/100ms
          Slow Blank    92.417k i/100ms
      New Slow Blank    77.581k i/100ms
-------------------------------------------------
          Fast Blank      2.287M (±11.7%) i/s -     11.267M
  Fast ActiveSupport      2.507M (± 8.1%) i/s -     12.496M
          Slow Blank      2.798M (± 4.5%) i/s -     13.955M
      New Slow Blank      1.523M (± 4.7%) i/s -      7.603M

Comparison:
          Slow Blank:  2798137.8 i/s
  Fast ActiveSupport:  2506713.8 i/s - 1.12x slower
          Fast Blank:  2287223.6 i/s - 1.22x slower
      New Slow Blank:  1522530.9 i/s - 1.84x slower


================== Test String Length: 136 ==================
Calculating -------------------------------------
          Fast Blank    85.992k i/100ms
  Fast ActiveSupport    83.403k i/100ms
          Slow Blank   107.259k i/100ms
      New Slow Blank    79.743k i/100ms
-------------------------------------------------
          Fast Blank      1.851M (±11.7%) i/s -      9.115M
  Fast ActiveSupport      1.955M (± 8.6%) i/s -      9.758M
          Slow Blank      2.761M (± 7.6%) i/s -     13.729M
      New Slow Blank      1.514M (± 8.3%) i/s -      7.496M

Comparison:
          Slow Blank:  2760863.7 i/s
  Fast ActiveSupport:  1954917.9 i/s - 1.41x slower
          Fast Blank:  1850951.5 i/s - 1.49x slower
      New Slow Blank:  1513753.1 i/s - 1.82x slower
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
