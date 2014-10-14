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

# simple rake task to output a changelog between two commits, tags ...
# output is formatted simply, commits are grouped under each author name
#
desc 'generate changelog with nice clean output'
task :changelog, :since_c, :until_c do |_, args|
  since_c = args[:since_c] || `git tag | head -1`.chomp
  until_c = args[:until_c]
  cmd = `git log --pretty='format:%ci::%an <%ae>::%s::%H' #{since_c}..#{until_c}`

  entries = {}
  changelog_content = ''

  cmd.split("\n").each do |entry|
    _, author, subject, hash = entry.chomp.split('::')
    entries[author] ||= []
    entries[author] << "#{subject} (#{hash})" unless subject =~ /Merge/
  end

  # generate clean output
  entries.keys.each do |author|
    changelog_content += "#{author}\n"
    entries[author].reverse.each { |entry| changelog_content += "  * #{entry}\n" }
  end

  puts changelog_content
end
