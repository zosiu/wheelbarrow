require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

desc 'Run specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.verbose = false
  t.rspec_opts = ['--format documentation',
                  '-t ~@skip-ci',
                  '--failure-exit-code 1']
end

desc 'Run rubocop'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.fail_on_error = true
  t.verbose = false
  t.formatters = ['RuboCop::Formatter::SimpleTextFormatter']
  t.options = ['-D']
end

desc 'Run things for ci'
task :ci do
  puts "\033[34mRunning rubocop:\033[0m"
  Rake::Task['rubocop'].invoke

  puts

  puts "\033[34mRunning rspec:\033[0m"
  Rake::Task['spec'].invoke
end
