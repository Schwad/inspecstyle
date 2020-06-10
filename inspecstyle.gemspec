require_relative 'lib/rubocop/inspecstyle/version'

Gem::Specification.new do |spec|
  spec.name          = "inspecstyle"
  spec.version       = RuboCop::InSpecStyle::VERSION
  spec.authors       = ["Nick Schwaderer"]
  spec.email         = ["nschwaderer@chef.io"]

  spec.summary       = %q{Preferred styling and performant InSpec code.}
  spec.description   = %q{InSpecStyle allows InSpec developers to write code with predictable styling and in a secure/performant manner.}
  spec.homepage      = "https://github.com/schwad/inspecstyle"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/schwad/inspecstyle"
  spec.metadata["changelog_uri"] = "https://github.com/schwad/inspecstyle"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rubocop'
end
