$VERBOSE = true

class ::String
  # Stub the original method to make sure it is redefined correctly.
  def blank?
    raise NotImplementedError
  end

  # Reference implementation of Active Support's String#blank? (8.1): the
  # [[:space:]] regexp, re-encoded when the string's encoding is incompatible.
  BLANK2_RE = /\A[[:space:]]*\z/
  BLANK2_ENCODED = Hash.new do |h, enc|
    h[enc] = Regexp.new(BLANK2_RE.source.encode(enc), BLANK2_RE.options | Regexp::FIXEDENCODING)
  end

  def blank2?
    empty? ||
      # === rather than match?, which Ruby < 2.4 lacks.
      begin
        BLANK2_RE === self
      rescue Encoding::CompatibilityError
        BLANK2_ENCODED[encoding] === self
      end
  end
end

ASCII_COMPATIBLE = Encoding.list.reject(&:dummy?).select(&:ascii_compatible?)

# Every valid single-character string of one or two bytes in every
# ASCII-compatible encoding, plus the BMP up to U+3100 in the wide Unicode
# encodings.
SWEEP_STRINGS = begin
  single_chars = lambda do |enc, byte_strings|
    byte_strings.map { |b| b.force_encoding(enc) }.select { |s| s.valid_encoding? && s.length == 1 }
  end
  two_bytes = (0x80..0xff).flat_map { |a| (0..0xff).map { |b| [a, b].pack('C*') } }
  strings = ASCII_COMPATIBLE.flat_map do |enc|
    single_chars.call(enc, (0..255).map(&:chr)) + single_chars.call(enc, two_bytes.map(&:dup))
  end
  %w[UTF-16LE UTF-16BE UTF-32LE UTF-32BE].each do |name|
    (0..0x3100).each do |cp|
      next if (0xD800..0xDFFF).cover?(cp)
      strings << cp.chr(Encoding::UTF_8).encode(name)
    end
  end
  strings
end

# Every Unicode space transcoded into every ASCII-compatible encoding that can
# represent it (up to four bytes, e.g. GB18030). Only compared with Active
# Support: String#strip itself raises on some of them on JRuby 9.4 and 10.1
# (https://github.com/jruby/jruby/issues/9776).
UNICODE_SPACES = [0x85, 0xa0, 0x1680, *0x2000..0x200a, 0x2028, 0x2029, 0x202f, 0x205f, 0x3000]
TRANSCODED_SPACES = ASCII_COMPATIBLE.product(UNICODE_SPACES).map do |enc, cp|
  begin
    cp.chr(Encoding::UTF_8).encode(enc)
  rescue EncodingError
    nil
  end
end.compact

def sweep_mismatches(strings = SWEEP_STRINGS)
  strings.reject { |s| yield(s) }.map { |s| "#{s.encoding}:#{s.bytes.map { |b| format('%02x', b) }.join}" }
end

require 'fast_blank'

describe String do
  it "works" do
    expect("".blank?).to eq(true)
    expect(" ".blank?).to eq(true)
    expect("\r\n".blank?).to eq(true)
    expect("\r\n\v\f\r\s".blank?).to eq(true)
    # NEL is not stripped by String#strip, but Active Support counts it as space.
    expect("\u0085".blank?).to eq(false)
    expect("\r\n\v\f\r\s\u0085".blank_as?).to eq(true)
  end

  it "provides a parity with active support function" do
    (16*16*16*16).times do |i|
      c = i.chr('UTF-8') rescue nil
      unless c.nil?
        expect("#{i.to_s(16)} #{c.blank_as?}").to eq("#{i.to_s(16)} #{c.blank2?}")
      end
    end


    (256).times do |i|
      c = i.chr('ASCII') rescue nil
      unless c.nil?
        expect("#{i.to_s(16)} #{c.blank_as?}").to eq("#{i.to_s(16)} #{c.blank2?}")
      end
    end
  end

  it "has parity with strip.length" do
    (256).times do |i|
      c = i.chr('ASCII') rescue nil
      unless c.nil?
        expect("#{i.to_s(16)} #{c.strip.length == 0}").to eq("#{i.to_s(16)} #{c.blank?}")
      end
    end
  end

  it "has parity with active support in every encoding" do
    expect(sweep_mismatches(SWEEP_STRINGS + TRANSCODED_SPACES) { |s| s.blank_as? == s.blank2? }).to eq([])
  end

  it "has parity with strip.length in every encoding" do
    expect(sweep_mismatches { |s| s.blank? == (s.strip.length == 0) }).to eq([])
  end

  it "rejects invalid byte sequences like strip and active support do" do
    invalid = "  \xff".dup.force_encoding(Encoding::UTF_8)
    expect { invalid.blank? }.to raise_error(ArgumentError)
    expect { invalid.blank_as? }.to raise_error(ArgumentError)
  end

  # JRuby and TruffleRuby have no Ractor.
  if defined?(Ractor)
    it "can be called from a non-main Ractor" do
      # begin/ensure rather than ensure in the do block: Ruby < 2.5 must parse this file.
      experimental = Warning[:experimental]
      begin
        Warning[:experimental] = false
        ractor = Ractor.new { ["  ".blank?, "  ".blank_as?] }
        result = ractor.respond_to?(:value) ? ractor.value : ractor.take
        expect(result).to eq([true, true])
      ensure
        Warning[:experimental] = experimental
      end
    end
  end

  it "treats \u0000 correctly" do
    # odd I know
    expect("\u0000".strip.length).to eq(0)
    expect("\u0000".blank_as?).to be_falsey
    expect("\u0000".blank?).to be_truthy
  end

end
