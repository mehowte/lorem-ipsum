require 'rake'
require 'rake/gempackagetask'
require 'rubygems'

def version
  `git describe --tags 2> /dev/null`.split('-')[0] || "0.0.1"
end

spec = Gem::Specification.new do |s|
  s.name    = 'lorem-ipsum'
  s.version = version

  s.summary     = 'A simple dummy text generator.'
  s.description = 'lorem-ipsum is a simple, trainable dummy text generator.'
  s.license     = 'MIT'

  s.authors   = ['Matt Austin']
  s.email     = 'maustin126@gmail.com'
  s.homepage  = 'http://github.com/maafy6/lorem-ipsum'

  s.require_paths = %w[lib]

  s.executables = 'lorem-ipsum'

  s.files = FileList['lib/**/*.rb'] +
      FileList['data/**/*']
end

Rake::GemPackageTask.new(spec) {}

