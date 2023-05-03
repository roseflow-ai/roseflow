# frozen_string_literal: true

require_relative "lib/roseflow/version"

Gem::Specification.new do |spec|
  spec.name = "roseflow"
  spec.version = Roseflow.gem_version
  spec.authors = ["Lauri Jutila"]
  spec.email = ["github@laurijutila.com"]

  spec.description = "Roseflow is a library for effortlessly building interactions with AI"
  spec.homepage = "https://github.com/ljuti/roseflow"

  spec.summary = "Effortless interactions with AI"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.2.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ljuti/roseflow"
  spec.metadata["changelog_uri"] = "https://github.com/ljuti/roseflow/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "activesupport", "~> 7.0"
  spec.add_dependency "anyway_config", "~> 2.0"
  spec.add_dependency "dry-struct", "~> 1.6"
  spec.add_dependency "dry-validation", "~> 1.10"
  spec.add_dependency "finite_machine", "~> 0.14"
  spec.add_dependency "hashie", "~> 5.0"
  spec.add_dependency "light-service", "~> 0.18"
  spec.add_dependency "phlex", "~> 1.8.1"
  spec.add_dependency "ulid-ruby", "~> 1.0"

  spec.add_development_dependency "pragmatic_segmenter", "~> 0.3"
  spec.add_development_dependency "roseflow-openai", "~> 0.1.0"
  spec.add_development_dependency "roseflow-pinecone", "~> 0.1.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
end
