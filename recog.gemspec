# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'recog/version'

Gem::Specification.new do |s|
  s.name        = 'recog'
  s.version     = Recog::VERSION
  s.required_ruby_version = '>= 2.5'
  s.authors = [
    'Rapid7 Research'
  ]
  s.email = [
    'research@rapid7.com'
  ]
  s.homepage    = 'https://www.github.com/rapid7/recog-ruby'
  s.summary     = 'Network service fingerprint database, classes, and utilities'
  s.description = '
    Recog is a framework for identifying products, services, operating systems, and hardware by matching
    fingerprints against data returned from various network probes. Recog makes it simply to extract useful
    information from web server banners, snmp system description fields, and a whole lot more.
  '.gsub(/\s+/, ' ').strip

  s.bindir        = 'recog/bin'
  s.files         = %w[Gemfile Rakefile COPYING LICENSE README.md recog.gemspec .yardopts] +
                    Dir.glob('lib/**/*.rb') +
                    Dir.glob('spec/**/*') +
                    Dir.glob('recog/xml/*') +
                    Dir.glob('recog/bin/recog_match')
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.executables   = s.files.grep(%r{^recog/bin/}).map { |f| File.basename(f) }
  s.require_paths = ['lib']

  gem_public_cert = ENV['GEM_PUBLIC_CERT']
  gem_private_key = ENV['GEM_PRIVATE_KEY']

  if gem_public_cert && gem_private_key
    s.cert_chain  = [gem_public_cert]
    s.signing_key = File.expand_path(gem_private_key)
  end

  # ---- Dependencies ----

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'yard'
  if RUBY_PLATFORM =~ /java/
    # markdown formatting for yard
    s.add_development_dependency 'kramdown'
  else
    # markdown formatting for yard
    s.add_development_dependency 'redcarpet'
  end
  s.add_development_dependency 'aruba'
  s.add_development_dependency 'simplecov'

  s.add_runtime_dependency 'nokogiri'
end
