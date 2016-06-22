require "./string_extension_wrapper.cr"

fun init = Init_fast_blank
  GC.init
  LibCrystalMain.__crystal_main(0, Pointer(Pointer(UInt8)).null)

  string = LibRuby.rb_define_class("String", LibRuby.rb_cObject)
  LibRuby.rb_define_method(string, "blank?", ->StringExtensionWrapper.blank?, 0)
  LibRuby.rb_define_method(string, "blank_as?", ->StringExtensionWrapper.blank?, 0)
end
