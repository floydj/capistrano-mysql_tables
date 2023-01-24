lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require_relative "lib/capistrano/mysql_tables/version"

Gem::Specification.new do |spec|
  spec.name          = "capistrano-mysql_tables"
  spec.version       = "0.0.3"
  spec.authors       = ["Jason Floyd"]
  spec.email         = ["jason.floyd@camfil.com"]

  spec.summary       = %q{Easily move tables between hosts in rails projects with Capistrano.}
  spec.homepage      = "https://github.com/floydj/capistrano-mysql_tables"
  # spec.homepage      = "https://rubygems.org/gems/capistrano-mysql_tables"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.add_runtime_dependency "capistrano", "~> 3.0"
end
