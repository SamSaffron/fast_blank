require 'mkmf'

if RUBY_ENGINE == 'truffleruby'
  # lib/fast_blank.rb never loads the C extension on TruffleRuby: write a
  # Makefile whose targets do nothing, so that installing the gem does not
  # need to build it.
  File.write('Makefile', "all install clean distclean:\n\t@:\n")
else
  # Ruby >= 3.0: lets the methods be called from non-main Ractors.
  have_func('rb_ext_ractor_safe', 'ruby.h')
  create_makefile 'fast_blank'
end
