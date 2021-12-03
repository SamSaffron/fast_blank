Gem::Specification.new do |s|
  s.name = 'fast_blank'
  s.version = '1.0.1'
  s.date = '2021-08-17'
  s.summary = 'Fast String blank? implementation'
  s.description = 'Provides a C-optimized method for determining if a string is blank'

  s.authors = ['Sam Saffron']
  s.email = 'sam.saffron@gmail.com'
  s.homepage = 'https://github.com/SamSaffron/fast_blank'
  s.license = 'MIT'

  s.require_paths = ['lib']
  s.files = [
    'MIT-LICENSE',
    'README.md',
    'benchmark',
    'lib/.gemkeep',
    'lib/fast_blank.rb',
  ]
  s.test_files = Dir['spec/**/*_spec.rb']

  if RUBY_ENGINE == 'jruby'
    s.platform = 'java'
    s.files += Dir['lib/**/*.jar'] + Dir['ext/**/*.java']
  else
    s.platform = Gem::Platform::RUBY
    s.extensions = ['ext/fast_blank/extconf.rb']
    s.files += %w[ext/fast_blank/fast_blank.c ext/fast_blank/extconf.rb]
  end

  s.rubygems_version = '1.3.7'

  s.add_development_dependency 'rake-compiler'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'benchmark-ips'
end

