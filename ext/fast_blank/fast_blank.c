#include <stdio.h>
#include <ruby.h>
#include <ruby/encoding.h>
#include <ruby/re.h>

#define STR_ENC_GET(str) rb_enc_from_index(ENCODING_GET(str))

/* Backward compatibility with Ruby 1.8 */
#ifndef RSTRING_PTR
#define RSTRING_PTR(s) (RSTRING(s)->ptr)
#endif
#ifndef RSTRING_LEN
#define RSTRING_LEN(s) (RSTRING(s)->len)
#endif


static VALUE
rb_str_blank(VALUE str)
{
  rb_encoding *enc;
  char *s, *e;

  enc = STR_ENC_GET(str);
  s = RSTRING_PTR(str);
  if (!s || RSTRING_LEN(str) == 0) return Qtrue;

  e = RSTRING_END(str);
  while (s < e) {
	  int n;
	  unsigned int cc = rb_enc_codepoint_len(s, e, &n, enc);

	  if (!rb_isspace(cc)) return Qfalse;
    s += n;
  }
  return Qtrue;
}


void Init_fast_blank( void )
{
  rb_define_method(rb_cString, "blank?", rb_str_blank, 0);
}
