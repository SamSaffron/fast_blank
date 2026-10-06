class ::String
  # Explicitly undefine method before redefining to avoid Ruby warnings.
  undef_method(:blank?) if method_defined?(:blank?)
end

case RUBY_ENGINE
  when 'jruby'
    require 'fast_blank.jar'
    JRuby::Util.load_ext("com.headius.jruby.fast_blank.FastBlankLibrary")
  when 'truffleruby'
    # TruffleRuby runs C extensions through an emulation layer that costs more
    # per call than its JIT-compiled regexps (measured 88x to 321x slower than
    # Active Support's String#blank? on TruffleRuby 40.0.0), so the same
    # semantics are provided in Ruby.
    module FastBlank
      # rb_isspace() plus NUL: exactly what String#strip removes. The class
      # holds the characters themselves, not \x escapes, which would not
      # survive re-encoding the source to UTF-16/UTF-32.
      BLANK_RE = Regexp.new("\\A[\t\n\v\f\r \0]*\\z").freeze
      # Active Support's definition of blank.
      BLANK_AS_RE = /\A[[:space:]]*\z/

      # Encodings that are not ASCII-compatible (UTF-16, UTF-32) need the
      # regexps re-encoded, as Active Support does. Selected up front rather
      # than by rescuing Encoding::CompatibilityError on every call.
      def self.encoded(re)
        Hash.new do |h, enc|
          h[enc] = Regexp.new(re.source.encode(enc), re.options | Regexp::FIXEDENCODING)
        end
      end
      BLANK_ENCODED = encoded(BLANK_RE)
      BLANK_AS_ENCODED = encoded(BLANK_AS_RE)
    end

    # The match is written inline in each method, as Active Support does.
    class ::String
      def blank?
        empty? ||
          (encoding.ascii_compatible? ? FastBlank::BLANK_RE : FastBlank::BLANK_ENCODED[encoding]).match?(self)
      end

      def blank_as?
        empty? ||
          (encoding.ascii_compatible? ? FastBlank::BLANK_AS_RE : FastBlank::BLANK_AS_ENCODED[encoding]).match?(self)
      end
    end
  else
    require 'fast_blank.so'
end
