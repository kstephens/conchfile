# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'conchfile/version'

Gem::Specification.new do |spec|
  spec.name          = "conchfile"
  spec.version       = Conchfile::VERSION
  spec.authors       = ["Kurt Stephens"]
  spec.email         = ["git@kurtstephens.com"]

  spec.summary       = %q{Yet Another Configuration File Library}
  spec.description   = %q{Yet Another Configuration File Library}
  spec.homepage      = "https://github.com/kstephens/conchfile"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.require_paths = ["lib"]

  spec.add_dependency "mime-types", "~> 3.1"
  spec.add_dependency "multi_json", "~> 1.12"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "pry-debugger", "~> 0.2.3"
  spec.add_development_dependency "guard", "~> 2.14"
  spec.add_development_dependency "guard-rspec", "~> 4.7.3"
  spec.add_development_dependency "awesome_print", "~> 1.7"
end
