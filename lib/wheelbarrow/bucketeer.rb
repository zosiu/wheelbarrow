require 'singleton'
require 'json'
require_relative 'utils'
require_relative 'authenticator'

module Wheelbarrow
  class Bucketeer
    include Singleton

    def initialize
      @bb_client = Authenticator.instance.oauth_client
    end

    def send_pull_request!(options = {})
      target_branch = options[:target_branch] || 'master'
      title = options[:target_title] || Utils.last_commit_message
      description = options[:description]

      payload = pull_request_body(target_branch, title, description).to_json

      res = @bb_client.post pull_request_url,
                            payload,
                            'Content-Type' => 'application/json'
      JSON.parse res.body
    end

    private

    def pull_request_body(target_branch, title, description)
      {
        title: title,
        description: description,
        source: pull_request_source,
        destination: pull_request_destination(target_branch)
      }
    end

    def pull_request_source
      {
        branch: {
          name: Utils.current_branch
        },
        repository: {
          full_name: Utils.repo_name
        }
      }
    end

    def pull_request_destination(target_branch)
      {
        branch: {
          name: target_branch
        }
      }
    end

    def pull_request_url
      "/api/2.0/repositories/#{Utils.repo_name}/pullrequests/"
    end
  end
end
