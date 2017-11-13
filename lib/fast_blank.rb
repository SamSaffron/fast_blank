case RUBY_ENGINE
  when 'jruby'
    require 'fast_blank.jar'
    JRuby::Util.load_ext("com.headius.jruby.fast_blank.FastBlankLibrary")
  else
    require 'fast_blank.so'
end
