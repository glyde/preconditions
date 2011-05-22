require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "preconditions"
  gem.homepage = "http://github.com/ctucker/preconditions"
  gem.license = "MIT"
  gem.summary = "Preconditions checking support inspired by Guava"
  gem.description = <<-EOD
The Preconditions library provides a simple set of methods for checking arguments being passed into a method.  Instead of writing custom checks and raising exceptions directly in your code you can use Preconditions to verify basic properties of your arguments (not-nil, satisfying a boolean expression, being of a certain type/duck-type) and raise the appropriate exception for you.
  EOD
  gem.email = "tucker+rubygems@glyde.com"
  gem.authors = ["tucker"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

# Task for CI reporting for Jenkins build
require 'ci/reporter/rake/rspec'
RSpec::Core::RakeTask.new(:ci_spec => ["ci:setup:rspec"]) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
