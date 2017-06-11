require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "codebreaker"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

task :play do
  Codebreaker::Game.new.run
end

