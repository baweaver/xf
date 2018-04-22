# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'xf'

Gem::Specification.new do |spec|
  repository_url = "https://www.github.com/baweaver/xf"

  spec.name = Xf::Identity.name
  spec.version = Xf::Identity.version
  spec.platform = Gem::Platform::RUBY
  spec.authors = ["Brandon Weaver"]
  spec.email = ["keystonelemur@gmail.com"]
  spec.homepage = repository_url
  spec.summary = "Xf - Transform functions for Enumerable collections"
  spec.license = "MIT"

  spec.metadata = {
    "source_code_uri" => "#{repository_url}/xf",
    "changelog_uri" => "#{repository_url}/blob/master/CHANGES.md",
    "bug_tracker_uri" => "#{repository_url}/issues"
  }

  # If you're developing, Gemsmith gets included and you should be on 2.5.x+,
  # if not or it's CI in a lesser Ruby version it _should not crash_
  if RUBY_VERSION >= '2.5.0'
    spec.add_development_dependency "gemsmith", "~> 12.0"
    spec.add_development_dependency "git-cop", "~> 2.2"
    spec.add_development_dependency "bundler-audit", "~> 0.6"
  end

  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0"

  spec.add_development_dependency "guard-rspec", "~> 4.7"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-byebug", "~> 3.5"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "reek", "~> 4.8"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "rubocop", "~> 0.54"
  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "qo", "~> 0.2"

  spec.files = Dir["lib/**/*"]
  spec.extra_rdoc_files = Dir["README*", "LICENSE*"]
  spec.require_paths = ["lib"]
end
