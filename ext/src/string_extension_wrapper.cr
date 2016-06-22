require "./lib_ruby"
require "./string_extension"

module StringExtensionWrapper
  def self.blank?(self : LibRuby::VALUE)
    str = String.from_ruby(self)
    str.blank?.to_ruby
  end
end
