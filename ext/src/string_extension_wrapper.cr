require "./lib_ruby"
require "./string_extension"

module StringExtensionWrapper
  def self.blank?(self : LibRuby::VALUE)
    return true.to_ruby if LibRuby.rb_str_length(self) == 0
    str = String.from_ruby(self)
    str.blank?.to_ruby
  rescue
    true.to_ruby
  end

  def self.blank_as?(self : LibRuby::VALUE)
    return true.to_ruby if LibRuby.rb_str_length(self) == 0
    str = String.from_ruby(self)
    str.blank_as?.to_ruby
  rescue
    true.to_ruby
  end

  def self.crystal_value(self : LibRuby::VALUE)
    str = String.from_ruby(self)
    str.to_ruby
  end
end
