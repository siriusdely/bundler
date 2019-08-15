# frozen_string_literal: true

require "pathname"

def run(*cmd)
  return if system(*cmd, :out => IO::NULL)
  raise "Running `#{cmd.join(" ")}` failed"
end

version = ENV["RGV"]
if version
  rubygems_path = Pathname.new("../../#{version}").expand_path(__dir__)
  unless rubygems_path.directory?
    rubygems_path = Pathname.new("../../tmp/rubygems").expand_path(__dir__)
    unless rubygems_path.directory?
      rubygems_path.parent.mkpath
      run("git", "clone", "https://github.com/rubygems/rubygems.git", rubygems_path.to_s)
    end

    Dir.chdir(rubygems_path) do
      run("git remote update")
      run("git", "checkout", version, "--quiet")
    end
  end

  $:.unshift File.expand_path("lib", rubygems_path)

  ENV["PATH"] = [File.expand_path("bin", rubygems_path), ENV["PATH"]].join(File::PATH_SEPARATOR)
end

require "rubygems"
