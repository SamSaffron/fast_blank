package com.headius.jruby.fast_blank;

import org.jcodings.Encoding;
import org.jruby.Ruby;
import org.jruby.RubyString;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.runtime.load.Library;
import org.jruby.util.ByteList;
import org.jruby.util.StringSupport;
import org.jruby.util.io.EncodingUtils;

// defineAnnotatedMethods(Class) and encCodepointLength(Ruby, ...) are deprecated
// in JRuby 10, but their replacements (defineMethods(ThreadContext, ...),
// encCodepointLength(ThreadContext, ...)) do not exist in JRuby 9.4, and the
// overload without a runtime throws a Java IllegalArgumentException instead of
// a Ruby ArgumentError on invalid bytes. Kept so one jar serves JRuby 9.4 and 10.
@SuppressWarnings("deprecation")
public class FastBlankLibrary implements Library {
    public void load(Ruby runtime, boolean wrap) {
        runtime.getString().defineAnnotatedMethods(FastBlankLibrary.class);
    }

    @JRubyMethod(name = "blank_as?")
    public static IRubyObject blank_as_p(ThreadContext context, IRubyObject self) {
        Encoding enc;
        int s, e;
        byte[] sBytes;

        Ruby runtime = context.runtime;

        RubyString str = (RubyString) self;
        enc = str.getEncoding();
        ByteList sByteList = str.getByteList();
        sBytes = sByteList.unsafeBytes();
        s = sByteList.begin();
        if (str.size() == 0) return context.tru;

        e = s + sByteList.realSize();

        // Fast path for 7-bit strings in ASCII-compatible encodings, as in blank?,
        // except that NUL is not blank here. scanForCodeRange() computes the code
        // range when getCodeRange() would still report it as unknown.
        if (enc.isAsciiCompatible() && str.scanForCodeRange() == StringSupport.CR_7BIT) {
            for (int i = s; i < e; i++) {
                if (sBytes[i] == 0 || !isSpace(sBytes[i])) return context.fals;
            }
            return context.tru;
        }

        // The table below lists Unicode code points; in any other encoding a code
        // is only meaningful to that encoding's own ctype table, which is what
        // Active Support's /[[:space:]]/ consults.
        boolean unicode = enc.isUnicode();
        int[] n = {0};
        while (s < e) {
            int cc = EncodingUtils.encCodepointLength(runtime, sBytes, s, e, n, enc);

            if (!unicode) {
                if (!enc.isSpace(cc)) return context.fals;
                s += n[0];
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
                    /* found */
                    break;
                default:
                    return context.fals;
            }
            s += n[0];
        }
        return context.tru;
    }

    @JRubyMethod(name = "blank?")
    public static IRubyObject blank_p(ThreadContext context, IRubyObject self) {
        RubyString str = (RubyString) self;

        if (str.size() == 0) return context.tru;

        ByteList sByteList = str.getByteList();
        byte[] sBytes = sByteList.unsafeBytes();
        int s = sByteList.begin();
        int e = s + sByteList.realSize();

        // Move to slower path if the string contains non 7-bit ASCII.
        if (str.scanForCodeRange() != StringSupport.CR_7BIT) return blankSlow(context, sBytes, s, e, str.getEncoding());

        for (int i = s; i < e; i++) {
            if (!isSpace(sBytes[i])) return context.fals;
        }

        return context.tru;
    }

    private static boolean isSpace(byte c) {
        return c == ' ' || ('\t' <= c && c <= '\r') || c == '\0';
    }

    private static IRubyObject blankSlow(ThreadContext context, byte[] bytes, int s, int e, Encoding enc) {
        Ruby runtime = context.runtime;
        int[] n = {0};

        while (s < e) {
            int cc = EncodingUtils.encCodepointLength(runtime, bytes, s, e, n, enc);

            if (!isSpaceCodepoint(cc) && cc != 0) return context.fals;
            s += n[0];
        }

        return context.tru;
    }

    // MRI: rb_isspace
    private static boolean isSpaceCodepoint(int codepoint) {
        return codepoint == ' ' || ('\t' <= codepoint && codepoint <= '\r');
    }
}
