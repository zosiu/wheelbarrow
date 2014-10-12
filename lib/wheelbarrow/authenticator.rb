require 'singleton'
require 'oauth'
require 'launchy'
require 'thor'
require_relative 'config'

module Wheelbarrow
  class Authenticator
    include Singleton

    attr_reader :oauth_client

    def initialize
      @config = Config.instance.fetch
      authenticate
      Config.instance.dump @config
    end

    private

    def shell
      @shell ||= Thor::Shell::Basic.new
    end

    def oauth_consumer
      @consumer ||= OAuth::Consumer.new @config[:consumer_key],
                                        @config[:consumer_secret],
                                        Config.instance.bitbucket_oauth_config
    end

    def fetch_consumer_creditetntials
      @config[:consumer_key] = shell.ask 'Enter your consumer_key:'
      @config[:consumer_secret] = shell.ask 'Enter your consumer secret:'
    end

    def fetch_token_creditentials
      request_token = oauth_consumer.get_request_token
      Launchy.open request_token.authorize_url
      verifier = shell.ask 'Authorize wheelbarrow and enter the verifier code you are assigned:'
      access_token = request_token.get_access_token oauth_verifier: verifier
      @config[:token] = access_token.token
      @config[:token_secret] = access_token.secret
    end

    def authenticate
      fetch_consumer_creditetntials unless @config[:consumer_key] && @config[:consumer_secret]
      fetch_token_creditentials unless @config[:token] && @config[:token_secret]

      @oauth_client ||= OAuth::AccessToken.new oauth_consumer,
                                               @config[:token],
                                               @config[:token_secret]
    end
  end
end
