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
    ext.source_version = '1.8'
    ext.target_version = '1.8'
  end
  # Install should not compile since it is already compiled.
  # Use 'rake compile' if you want to re-compile for development.
  task :default => :spec
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

