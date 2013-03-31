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

const unsigned int as_blank[26] = {9, 0xa, 0xb, 0xc, 0xd,
  0x20, 0x85, 0xa0, 0x1680, 0x180e, 0x2000, 0x2001,
  0x2002, 0x2003, 0x2004, 0x2005, 0x2006, 0x2007, 0x2008,
  0x2009, 0x200a, 0x2028, 0x2029, 0x202f, 0x205f, 0x3000
};

static VALUE
rb_str_blank_as(VALUE str)
{
  rb_encoding *enc;
  char *s, *e;
  int i;
  int found;

  enc = STR_ENC_GET(str);
  s = RSTRING_PTR(str);
  if (!s || RSTRING_LEN(str) == 0) return Qtrue;

  e = RSTRING_END(str);
  while (s < e) {
	  int n;
	  unsigned int cc = rb_enc_codepoint_len(s, e, &n, enc);

    found = 0;
    for(i=0;i<26;i++){
      unsigned int current = as_blank[i];
      if(current == cc) {
        found = 1;
        break;
      }
      if(cc < current){
        break;
      }
    }

	  if (!found) return Qfalse;
    s += n;
  }
  return Qtrue;
}

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

	  if (!rb_isspace(cc) && cc != 0) return Qfalse;
    s += n;
  }
  return Qtrue;
}


void Init_fast_blank( void )
{
  rb_define_method(rb_cString, "blank?", rb_str_blank, 0);
  rb_define_method(rb_cString, "blank_as?", rb_str_blank_as, 0);
}
