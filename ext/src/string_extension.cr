# adapted from https://github.com/phoffer/inflector.cr/blob/master/src/inflector/string.cr
struct Char
  # activesupport compatible
  def blank?
    case ord
    when 9, 0xa, 0xb, 0xc, 0xd, 0x20, 0x85, 0xa0, 0x1680, 0x180e,
          0x2000, 0x2001, 0x2002, 0x2003, 0x2004, 0x2005, 0x2006,
          0x2007, 0x2008, 0x2009, 0x200a, 0x2028, 0x2029, 0x202f,
          0x205f, 0x3000 then true
    else
      false
    end
  end

  # same way C Ruby implements it
  def is_blank
    self == ' ' || ('\t' <= self <= '\r')
  end
end

class String
  # A string is blank if it's empty or contains whitespaces only:
  #
  #   ''.blank?       # => true
  #   '   '.blank?    # => true
  #   "\t\n\r".blank? # => true
  #   ' blah '.blank? # => false
  #
  # Unicode whitespace is supported:
  #
  #   "\u00a0".blank? # => true
  #
  # @return [true, false]
  def blank_as?
    return true if self.nil? || self.size == 0
    each_char { |char| return false if !char.blank? }
    return true
  end

  def blank?
    return true if self.nil? || self.size == 0
    each_char { |char| return false if !char.is_blank }
    return true
  end
end
