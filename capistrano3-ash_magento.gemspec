# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/ash_magento/version'


Gem::Specification.new do |gem|
  gem.name          = "capistrano3-ash_magento"
  gem.version       = Capistrano::AshMagento::VERSION
  gem.authors       = ["Josh Johnson"]
  gem.email         = ["josh@augustash.com"]
  gem.description   = %q{Magento specific tasks for Capistrano}
  gem.summary       = %q{Magento specific tasks for Capistrano 3}
  gem.homepage      = "https://github.com/augustash/capistrano3-ash_magento"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "capistrano", "~> 3.1"
end
