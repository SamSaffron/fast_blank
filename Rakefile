require 'bundler'
require 'bundler/gem_tasks'
Bundler.setup

require 'rake'
require 'rake/extensiontask'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

gem = Gem::Specification.load( File.dirname(__FILE__) + '/fast_blank.gemspec' )

if RUBY_ENGINE == 'jruby'
  require 'rake/javaextensiontask'
  Rake::JavaExtensionTask.new( 'fast_blank', gem ) do |ext|
    ext.ext_dir = 'ext/java'
    # Java 8 bytecode keeps the jar loadable by JRuby 9.4, which runs on Java 8;
    # newer javac versions flag that target as obsolete, which is expected.
    ext.source_version = '1.8'
    ext.target_version = '1.8'
    ext.lint_option = 'all,-options'
  end
elsif RUBY_ENGINE == 'truffleruby'
  # lib/fast_blank.rb implements the methods in Ruby there: nothing to build.
  task :compile
else
  Rake::ExtensionTask.new( 'fast_blank', gem )
end

Gem::PackageTask.new gem  do |pkg|
  pkg.need_zip = pkg.need_tar = false
end

RSpec::Core::RakeTask.new :spec  do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => [:compile, :spec]

task :bench => [:compile] do
  exec './benchmark'
end

namespace :bench do
  desc 'Compare with Active Support (needs `bundle config set --local with bench`)'
  task :activesupport => [:compile] do
    ruby 'bench/compare_activesupport.rb'
  end
end

