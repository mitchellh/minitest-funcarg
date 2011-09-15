$:.unshift File.expand_path("../lib", __FILE__)
require "minitest/funcarg/version"

Gem::Specification.new do |s|
  s.name          = "minitest-funcarg"
  s.version       = Minitest::Funcarg::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Mitchell Hashimoto"]
  s.email         = ["mitchell.hashimoto@gmail.com"]
  s.summary       = "minitest-funcarg provides funcargs for minitest"
  s.description   = "minitest-funcarg provides funcargs for minitest"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "minitest-funcarg"

  s.add_dependency "minitest", "~> 2.6.0"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path  = 'lib'
end

