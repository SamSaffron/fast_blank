# Compares fast_blank's blank? and blank_as? with Active Support's String#blank?.
#
# Run with `bundle exec rake bench:activesupport` after
# `bundle config set --local with bench` (Active Support is an optional group).
#
# Without arguments, prints a table of speed ratios. Each measurement runs in
# its own process, calls the method directly (no __send__) on 64 distinct copies
# of the string, and consumes every result: sharing one call site between
# variants, or calling a constant string, lets the JRuby and TruffleRuby JITs
# fold the call and gives numbers off by an order of magnitude.

require 'rbconfig'

STRINGS = {
  '""' => '',
  '6 blanks' => "\r\n\r\n  ",
  '14 chars of text' => 'this is a test',
  '24 chars, leading blanks' => '   this is a longer test',
  '136 chars, multi-line text' => ("   this is a longer test\n" * 5).chomp,
  '136 spaces' => ' ' * 136,
  'Unicode blanks' => "  　   ",
  'Unicode text' => "   héllo wörld"
}
VARIANTS = { 'blank?' => :blank?, 'blank_as?' => :blank_as?, 'activesupport' => :as_blank? }

def measure(variant, label)
  require 'active_support'
  require 'active_support/core_ext/object/blank'
  String.send(:alias_method, :as_blank?, :blank?)
  String.send(:remove_method, :blank?)
  $LOAD_PATH.unshift File.expand_path('../lib', __dir__)
  require 'fast_blank'

  pool = Array.new(64) { STRINGS.fetch(label).dup }
  batch = 100_000
  run = eval(<<-RUBY)
    lambda do
      i = 0; c = 0
      while i < batch
        c += 1 if pool[i & 63].#{VARIANTS.fetch(variant)}
        i += 1
      end
      c
    end
  RUBY
  now = lambda { Process.clock_gettime(Process::CLOCK_MONOTONIC) }
  warmup, time = RUBY_ENGINE == 'ruby' ? [1, 2] : [5, 3]

  sink = 0
  t = now.call
  sink += run.call while now.call - t < warmup
  calls = 0
  t0 = now.call
  while (elapsed = now.call - t0) < time
    sink += run.call
    calls += batch
  end
  puts(sink >= 0 ? calls / elapsed : 0)
end

def report
  require 'active_support/version'
  puts "#{RUBY_DESCRIPTION}, activesupport #{ActiveSupport::VERSION::STRING}"
  puts
  puts '| String | blank? | blank_as? |'
  puts '|---|---|---|'
  STRINGS.each_key do |label|
    ips = VARIANTS.keys.map do |variant|
      out = IO.popen([RbConfig.ruby, __FILE__, variant, label], &:read)
      raise "measurement failed: #{variant} #{label}" unless $?.success?
      out.to_f
    end
    puts format('| %s | %.2fx | %.2fx |', label, ips[0] / ips[2], ips[1] / ips[2])
  end
end

ARGV.empty? ? report : measure(*ARGV)
