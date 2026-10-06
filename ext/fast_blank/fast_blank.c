#include <ruby.h>
#include <ruby/encoding.h>
#include <ruby/version.h>

#define STR_ENC_GET(str) rb_enc_from_index(ENCODING_GET(str))

#ifndef RUBY_API_VERSION_CODE
# define ruby_version_before_2_2() 1
#else
# define ruby_version_before_2_2() (RUBY_API_VERSION_CODE < 20200)
#endif

/* Fast path for 7-bit strings in ASCII-compatible encodings: every byte is a
   whole character, so no code point decoding is needed. */
static int
str_ascii_only_p(VALUE str, rb_encoding *enc)
{
  return rb_enc_asciicompat(enc) && rb_enc_str_coderange(str) == ENC_CODERANGE_7BIT;
}

static VALUE
ascii_blank(const char *s, const char *e, int nul_is_blank)
{
  for (; s < e; s++) {
    if (!rb_isspace((unsigned char)*s) && !(nul_is_blank && *s == '\0')) return Qfalse;
  }
  return Qtrue;
}

static VALUE
rb_str_blank_as(VALUE str)
{
  rb_encoding *enc;
  char *s, *e;
  int unicode;

  enc = STR_ENC_GET(str);
  s = RSTRING_PTR(str);
  if (RSTRING_LEN(str) == 0) return Qtrue;
  if (str_ascii_only_p(str, enc)) return ascii_blank(s, RSTRING_END(str), 0);

  /* The table below lists Unicode code points; in any other encoding a code
     is only meaningful to that encoding's own ctype table, which is what
     Active Support's /[[:space:]]/ consults. */
  unicode = rb_enc_unicode_p(enc);

  e = RSTRING_END(str);
  while (s < e) {
    int n;
    unsigned int cc = rb_enc_codepoint_len(s, e, &n, enc);

    if (!unicode) {
      /* rb_enc_isspace() also accepts some multibyte codes (Emacs-Mule,
         stateless-ISO-2022-JP) that /[[:space:]]/ does not match. */
      if (n > 1 || !rb_enc_isspace(cc, enc)) return Qfalse;
      s += n;
      continue;
    }

    switch (cc) {
      case 9:
      case 0xa:
      case 0xb:
      case 0xc:
      case 0xd:
      case 0x20:
      case 0x85:
      case 0xa0:
      case 0x1680:
      case 0x2000:
      case 0x2001:
      case 0x2002:
      case 0x2003:
      case 0x2004:
      case 0x2005:
      case 0x2006:
      case 0x2007:
      case 0x2008:
      case 0x2009:
      case 0x200a:
      case 0x2028:
      case 0x2029:
      case 0x202f:
      case 0x205f:
      case 0x3000:
#if ruby_version_before_2_2()
      case 0x180e:
#endif
          /* found */
          break;
      default:
          return Qfalse;
    }
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
  if (RSTRING_LEN(str) == 0) return Qtrue;
  if (str_ascii_only_p(str, enc)) return ascii_blank(s, RSTRING_END(str), 1);

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
  /* Both methods are pure functions of their receiver, with no global state. */
#ifdef HAVE_RB_EXT_RACTOR_SAFE
  rb_ext_ractor_safe(true);
#endif
  rb_define_method(rb_cString, "blank?", rb_str_blank, 0);
  rb_define_method(rb_cString, "blank_as?", rb_str_blank_as, 0);
}
