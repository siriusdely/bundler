# frozen_string_literal: true

module Gem
  if version = ENV["BUNDLER_SPEC_RUBYGEMS_VERSION"]
    remove_const(:VERSION) if const_defined?(:VERSION)
    VERSION = version
  end

  class Platform
    @local = new(ENV["BUNDLER_SPEC_PLATFORM"]) if ENV["BUNDLER_SPEC_PLATFORM"]
  end
  @platforms = [Gem::Platform::RUBY, Gem::Platform.local]

  # We only need this hack for rubygems versions without the BundlerVersionFinder
  if Gem::Version.new(Gem::VERSION) < Gem::Version.new("2.7.0") || ENV["BUNDLER_SPEC_DISABLE_DEFAULT_BUNDLER_GEM"]
    @path_to_default_spec_map.delete_if do |_path, spec|
      spec.name == "bundler"
    end
  end
end

if ENV["BUNDLER_SPEC_VERSION"]
  require "bundler/version"

  module Bundler
    remove_const(:VERSION) if const_defined?(:VERSION)
    VERSION = ENV["BUNDLER_SPEC_VERSION"].dup
  end
end

if ENV["BUNDLER_SPEC_WINDOWS"] == "true"
  require "bundler/constants"

  module Bundler
    remove_const :WINDOWS if defined?(WINDOWS)
    WINDOWS = true
  end
end

class Object
  if ENV["BUNDLER_SPEC_RUBY_ENGINE"]
    if RUBY_ENGINE != "jruby" && ENV["BUNDLER_SPEC_RUBY_ENGINE"] == "jruby"
      begin
        # this has to be done up front because psych will try to load a .jar
        # if it thinks its on jruby
        require "psych"
      rescue LoadError
        nil
      end
    end

    remove_const :RUBY_ENGINE
    RUBY_ENGINE = ENV["BUNDLER_SPEC_RUBY_ENGINE"]

    remove_const :RUBY_ENGINE_VERSION
    RUBY_ENGINE_VERSION = ENV["BUNDLER_SPEC_RUBY_ENGINE_VERSION"]
  end
end
