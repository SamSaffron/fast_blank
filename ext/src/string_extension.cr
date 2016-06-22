# exact port from ActiveSupport in Ruby:
# https://github.com/rails/rails/blob/42b0c942520e59399d70c2170253aa5275a42af1/activesupport/lib/active_support/core_ext/object/blank.rb#L101-L119
class String
  BLANK_RE = /\A[[:space:]]*\z/

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
  def blank?
    BLANK_RE === self
  end
end
