require 'thor'
require_relative 'version'

module Wheelbarrow
  class CLI < Thor
    desc 'version', 'Show wheelbarrow version'
    def version
      puts Wheelbarrow::VERSION
    end
    map ['-v', '--version'] => :version

    desc 'pull-request', 'send a pull request to BitBucket'
    def pull_request
      say 'o hai!'
    end
    map ['pull-request', 'pr'] => :pull_request

    default_task :pull_request
  end
end
