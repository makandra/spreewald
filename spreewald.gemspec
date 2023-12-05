# -*- encoding: utf-8 -*-
$: << File.expand_path('../lib', __FILE__)
require 'spreewald_support/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Tobias Kraze"]
  gem.email         = ["tobias@kraze.eu"]
  gem.description   = %q{A collection of cucumber steps we use in our projects, including steps to check HTML, tables, emails and some utility methods.}
  gem.summary       = %q{Collection of useful cucumber steps.}
  gem.homepage      = "https://github.com/makandra/spreewald"
  gem.license       = 'MIT'
  gem.metadata = {
    'source_code_uri' => gem.homepage,
    'bug_tracker_uri' => gem.homepage + '/issues',
    'changelog_uri' => gem.homepage + '/blob/master/CHANGELOG.md',
    'rubygems_mfa_required' => 'true',
  }

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^tests/})
  gem.name          = "spreewald"
  gem.require_paths = ["lib"]
  gem.version       = Spreewald::VERSION

  gem.add_dependency('cucumber')
  gem.add_dependency('cucumber_priority', '>=0.3.0')
  gem.add_dependency('rspec', '>= 2.13.0')
  gem.add_dependency('capybara')
  gem.add_dependency('xpath')
end
