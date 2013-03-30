### String blank? Ruby Extension

`fast_blank` is a simple extension which provides a fast implementation of active support's string#blank? function

### How do you use it?

    require 'fast_blank'

### How fast is "Fast"?


About 5-9x faster than current active support, on my machine (your mileage my vary):

    $ ./benchmark

```
                          user     system      total        real
Fast Blank 0    :     0.070000   0.000000   0.070000 (  0.073033)
Slow Blank 0    :     0.480000   0.000000   0.480000 (  0.475497)
Fast Blank 6    :     0.150000   0.000000   0.150000 (  0.151790)
Slow Blank 6    :     0.670000   0.000000   0.670000 (  0.663709)
Fast Blank 14    :    0.110000   0.000000   0.110000 (  0.115449)
Slow Blank 14    :    0.880000   0.000000   0.880000 (  0.877265)
Fast Blank 24    :    0.160000   0.000000   0.160000 (  0.162566)
Slow Blank 24    :    0.870000   0.000000   0.870000 (  0.864067)
Fast Blank 136    :   0.120000   0.000000   0.120000 (  0.125531)
Slow Blank 136    :   0.890000   0.000000   0.890000 (  0.889991)

```


Additionally, this gem allocates no strings during the test, making it less of a GC burden.


###Compatability note: 

fast_blank implements string.blank? as MRI would have it implemented, meaning it has 100% parity with `String#strip.length == 0`. 

Active Supports version looks also at unicode spaces  
for example: `"\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200A\u202F\u205F\u3000".blank?` is true in Active Support even though fast_blank would treat it as not blank.

It is tricky, I can introduce parity with Active Support with little perf loss, but I worry about having an API on String that is inconsistent.

Author: Sam Saffron sam.saffron@gmail.com
http://github.com/SamSaffron/fast_blank  
License: MIT


(gem template based on https://github.com/CodeMonkeySteve/fast_xor )
