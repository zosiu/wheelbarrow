require 'wheelbarrow'

module Wheelbarrow
  class CLI < Thor
    desc 'version', 'show wheelbarrow version'
    def version
      puts Wheelbarrow::VERSION
    end
    map ['-v', '--version'] => :version

    desc 'pull-request', 'send a pull request to BitBucket'
    method_option :title,
                  aliases: '-t',
                  desc: 'Pull request title',
                  default: Utils.last_commit_message
    method_option :description,
                  aliases: '-d',
                  desc: 'Pull request description',
                  default: ''
    method_option :target_branch,
                  aliases: '-b',
                  desc: 'Target branch for the pull request',
                  default: 'master'
    def pull_request
      Utils.ensure_within_git! do
        args = { title: options[:title],
                 description: options[:description],
                 target_branch: options[:target_branch] }

        pr_response = Bucketeer.instance.send_pull_request! args
        puts pretty_pr_status(pr_response)
      end
    rescue => e
      puts e.message
    end
    map ['pull-request', 'pr'] => :pull_request

    default_task :pull_request

    no_tasks do
      def pretty_pr_status(response)
        if response['error']
          pretty_failed_pr_message response['error']
        else
          pretty_successful_pr_message
        end
      end

      def pretty_successful_pr_message
        set_color('YAY, pull request submitted successfully!', :green)
      end

      def pretty_failed_pr_message(errors)
        status = set_color('OH NOES, something went wrong...', :red, :bold)
        message = set_color("  #{errors['message']}", :red)
        field_errors = errors['fields'] || []
        field_messages = field_errors.map do |field, msg|
          set_color("    #{field}: #{msg}", :red)
        end.join "\n"

        [status, message, field_messages].join "\n"
      end
    end
  end
end
