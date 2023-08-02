# frozen_string_literal: true

require "anyway_config"

Anyway::Settings.use_local_files = true

require "roseflow"
require "webmock/rspec"
require "vcr"
require "coveralls"
require "simplecov"

Coveralls.wear!
SimpleCov.start

VCR.configure do |config|
  config.filter_sensitive_data("<OPENAI_KEY>") { Roseflow::OpenAI::Config.new.api_key }
  config.filter_sensitive_data("<OPENAI_ORGANIZATION_ID>") { Roseflow::OpenAI::Config.new.organization_id }
  config.filter_sensitive_data("<OPENROUTER_KEY>") { Roseflow::OpenRouter::Config.new.api_key }
end

Dir[File.join(File.dirname(__FILE__), "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr"
  config.hook_into :webmock
end
