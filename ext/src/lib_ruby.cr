# copied straight from crystalized_ruby while there is no proper shard (working on it)
lib LibRuby
  type VALUE = Void*
  type METHOD_FUNC = VALUE -> VALUE
  type ID = Void*

  $rb_cObject : VALUE
  $rb_cNumeric : VALUE
  $rb_cBasicObject : VALUE

  # generic
  fun rb_type(value : VALUE) : Int32 # can't get this working :/
  fun rb_any_to_s(value : VALUE) : UInt8*
  fun rb_class2name(value : VALUE) : UInt8*
  # fun rb_type(value : VALUE) : UInt8*
  fun rb_funcall(value : VALUE, method : ID, argc : Int32) : VALUE
  # fun rb_nil_p(value : VALUE) : Boolean # not sure how to handle this
  fun rb_obj_dup(value : VALUE) : VALUE

  # integers
  fun rb_num2int(value : VALUE) : Int32
  fun rb_num2dbl(value : VALUE) : Float32
  fun rb_int2inum(value : Int32) : VALUE

  # strings
  fun rb_str_to_str(value : VALUE) : VALUE
  fun rb_string_value_cstr(value_ptr : VALUE*) : UInt8*
  fun rb_str_new_cstr(str : UInt8*) : VALUE

  fun rb_id2sym(value : ID) : VALUE
  fun rb_intern(name : UInt8*) : ID

  # regexp
  fun rb_reg_new_str(str : VALUE, options : Int32) : VALUE # re.c:2792

  # arrays
  fun rb_ary_new() : VALUE
  fun rb_ary_push(array : VALUE, value : VALUE)
  fun rb_ary_length(array : VALUE) : Int32
  fun rb_ary_shift(array : VALUE) : VALUE

  # hashes
  fun rb_hash_new() : VALUE
  fun rb_hash_aset(hash : VALUE, key : VALUE, value : VALUE)
  fun rb_hash_foreach(hash : VALUE, callback : (Int32, Void* ->), data : Void*)
  fun rb_hash_keys(hash : VALUE)

  fun rb_define_class(name : UInt8*, super : VALUE) : VALUE
  fun rb_define_module(name : UInt8*, super : VALUE) : VALUE
  fun rb_define_method(klass : VALUE, name : UInt8*, func : METHOD_FUNC, argc : Int32)
  fun rb_define_singleton_method(klass : VALUE, name : UInt8*, func : METHOD_FUNC, argc : Int32)
end

lib LibRuby1
  type METHOD_FUNC = LibRuby::VALUE, LibRuby::VALUE -> LibRuby::VALUE # STUB
  fun rb_define_method(klass : LibRuby::VALUE, name : UInt8*, func : METHOD_FUNC, argc : Int32)
  fun rb_define_singleton_method(klass : LibRuby::VALUE, name : UInt8*, func : METHOD_FUNC, argc : Int32)
end

lib LibRuby2
  type METHOD_FUNC = LibRuby::VALUE, LibRuby::VALUE, LibRuby::VALUE -> LibRuby::VALUE
  fun rb_define_method(klass : LibRuby::VALUE, name : UInt8*, func : METHOD_FUNC, argc : Int32)
  fun rb_define_singleton_method(klass : LibRuby::VALUE, name : UInt8*, func : METHOD_FUNC, argc : Int32)
end

module RubyImporter
  def self.import_hash_key(&callback : Int32 ->)  #(key: VALUE, val : VALUE, data : Void*)
    @@callback = callback
    boxed_data = Box.box(callback)

    # LibRuby.rb_hash_foreach(->(key, tick, data) {
    #   # Now we turn data back into the Proc, using Box.unbox
    #   data_as_callback = Box(typeof(callback)).unbox(data)
    #   # And finally invoke the user's callback
    #   data_as_callback.call(tick)
    # }, boxed_data)
    # String.from_ruby(key)
    "hi".to_ruby
  end
# end

# class Object
  def self.scalar_from_ruby(obj : LibRuby::VALUE, klass_name : String = "")
    klass_name = rb_class(obj) if klass_name == ""
    case klass_name
    when "NilClass"
      nil
    when "TrueClass"
      true
    when "FalseClass"
      false
    when "String"
      String.from_ruby(obj)
    when "Fixnum"
      Int32.from_ruby(obj)
    when "Bignum", "Integer"
      # puts Int.from_ruby(obj).inspect
      Int.from_ruby(obj)
    when "Regexp"
      Regex.from_ruby(obj)
    when "Float"
      Float.from_ruby(obj)
    else
      "sorry :/"
    end
  end
  def self.from_ruby(obj : LibRuby::VALUE)
    case (klass_name = rb_class(obj))
    when "Array"
      Array.from_ruby(obj)
    else
      scalar_from_ruby(obj, klass_name)
    end
  end
  RB_method_class = LibRuby.rb_intern("class")
  def self.rb_class(obj : LibRuby::VALUE)
    rb_klass = LibRuby.rb_funcall(obj, RB_method_class, 0)
    ptr = LibRuby.rb_class2name(rb_klass)
    cr_str = String.new(ptr)
  end
  RB_method_to_s = LibRuby.rb_intern("to_s")
  def self.rb_any_to_str(obj)
    str = LibRuby.rb_funcall(obj, RB_method_to_s, 0)
    c_str = LibRuby.rb_string_value_cstr(pointerof(str))
    cr_str = String.new(c_str)
  end
end

struct Symbol
  def to_ruby
    LibRuby.rb_id2sym(LibRuby.rb_intern(self.to_s))
  end
end

class Regex
  RB_REGEX_INT = {
    Regex::Options::IGNORE_CASE  => 1,
    Regex::Options::MULTILINE    => 2,
    Regex::Options::EXTENDED     => 4,
  }
  def to_ruby
    code = RB_REGEX_INT.reduce(0){ |code, ( k, i )| self.options.includes?(k) ? code + i : code }
    LibRuby.rb_reg_new_str(self.source.to_ruby, code)
  end
  RB_REGEX_OPTIONS = {
    'i' => Regex::Options::IGNORE_CASE,
    'm' => Regex::Options::MULTILINE,
    'x' => Regex::Options::EXTENDED,
  }
  def self.from_ruby(val : LibRuby::VALUE) # needs improvement
    str = RubyImporter.rb_any_to_str(val)
    self.from_ruby(str)
  end
  def self.from_ruby(str : String)
    options = str[2..5].split('-').first
    exp = str[7..-2]
    options_enum = options.chars.reduce(Regex::Options::None) { |enum_obj, char| enum_obj | RB_REGEX_OPTIONS[char] }
    new(exp, options_enum)
  end
end

class Array
  def to_ruby
    LibRuby.rb_ary_new().tap do |rb_array|
      self.each do |val|
        val.inspect # stops working without this. no idea why. seriously, comment this line and it fails (at least when spitting out an array that came from ruby)
        LibRuby.rb_ary_push(rb_array, val.to_ruby)
      end
    end
  end
  def self.from_ruby(ary) # this is awful
    rb_ary = LibRuby.rb_obj_dup(ary)
    element = LibRuby.rb_ary_shift(rb_ary)
    element = RubyImporter.scalar_from_ruby(element)
    arr = [element]
    until element.is_a?(Nil)
      element = LibRuby.rb_ary_shift(rb_ary)
      element = RubyImporter.scalar_from_ruby(element)
      arr << element
    end
    arr.pop
    arr
  end
end

class Hash
  def to_ruby
    LibRuby.rb_hash_new().tap do |rb_hash|
      self.each do |k, v|
        LibRuby.rb_hash_aset(rb_hash, k.to_ruby, v.to_ruby)
      end
    end
  end
  def self.from_ruby
    # RubyImporter.import_hash_key do |tick|
    #   puts tick
    # end
    "hi"
  end
end

struct Nil
  def to_ruby
    Pointer(Void).new(8_u64).as(LibRuby::VALUE)
  end
end

struct Bool
  def to_ruby
    Pointer(Void).new(self ? 20_u64 : 0_u64).as(LibRuby::VALUE)
  end
  def self.from_ruby
    #
  end
end

class String
  def to_ruby
    LibRuby.rb_str_new_cstr(self)
  end

  def self.from_ruby(str : LibRuby::VALUE)
    rb_str = LibRuby.rb_str_to_str(str)
    c_str = LibRuby.rb_string_value_cstr(pointerof(rb_str))
    cr_str = String.new(c_str)
  end
end

struct Int
  def to_ruby
    LibRuby.rb_int2inum(self)
  end

  def self.from_ruby(int)
    LibRuby.rb_num2int(int)
  end
end
struct Int32
  def to_ruby
    LibRuby.rb_int2inum(self)
  end

  def self.from_ruby(int)
    LibRuby.rb_num2int(int)
  end
end
struct Float
  def self.from_ruby(float)
    LibRuby.rb_num2dbl(float)
  end
  def to_ruby
    to_i.to_ruby
  end
end
