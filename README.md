### String blank? Ruby Extension

+fast_blank+ is a simple extension which provides a fast implementation of active support's string#blank? function

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

<table>
<tr><th>Author</th><td>Sam Saffron ((sam.saffron@gmail.com)[mailto:sam.saffron@gmail.com])</td>
<tr>Website</tr><td>http://github.com/SamSaffron/fast_blank</td>
<tr>Copyright</tr><td>Copyright (c) 2009-2013 Sam Saffron</td>
<tr>License</tr><td>MIT</td>
</table>

(gem template based on https://github.com/CodeMonkeySteve/fast_xor )
