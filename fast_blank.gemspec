Gem::Specification.new do |s|
  s.name = 'fast_blank'
  s.version = '0.0.1'
  s.date = '2013-03-29'
  s.summary = 'Fast String blank? implementation'
  s.description = 'Provides a C-optimized method for determining if a string is blank'

  s.authors = ['Sam Saffron']
  s.email = 'sam.saffron@gmail.com'
  s.homepage = ''

  s.extensions = ['ext/fast_blank/extconf.rb']
  s.require_paths = ['lib']
  s.files = [
    'MIT-LICENSE',
    'README.md',
    'benchmark',
    'lib/.gemkeep',
    'ext/fast_blank/fast_blank.c',
    'ext/fast_blank/extconf.rb',
  ]
  s.test_files = Dir['spec/**/*_spec.rb']

  s.platform = Gem::Platform::RUBY
  s.rubygems_version = '1.3.7'

  s.add_dependency 'rake'
  s.add_dependency 'rake-compiler'

  s.add_development_dependency 'rspec'
end

