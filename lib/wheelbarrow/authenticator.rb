require 'rubygems'
require 'singleton'
require 'oauth'
require 'yaml'
require 'highline/import'
require 'launchy'

module Wheelbarrow
  class Authenticator
    include Singleton

    attr_reader :oauth_client

    def initialize
      load_config
      authenticate
      dump_config
    end

    def config_file_path
      File.expand_path "#{config_dir}/#{config_file_name}"
    end

    def config_file_name
      'config.yml'
    end

    def config_dir
      File.expand_path('~/.wheelbarrow')
    end

    private

    def create_config_dir
      Dir.mkdir(config_dir) unless File.directory?(config_dir)
    end

    def load_config
      @config = YAML.load_file config_file_path
    rescue Errno::ENOENT
      @config = {}
    end

    def dump_config
      create_config_dir

      stringified_config = @config.map { |k, v| [k, v.to_s] }.to_h
      File.open(config_file_path, 'w') { |f| YAML.dump stringified_config, f  }
    end

    def oauth_consumer
      @consumer ||= OAuth::Consumer.new @config[:consumer_key],
                                        @config[:consumer_secret],
                                        site: 'https://bitbucket.org',
                                        request_token_path: '/!api/1.0/oauth/request_token',
                                        authorize_path: '/!api/1.0/oauth/authenticate',
                                        access_token_path: '/!api/1.0/oauth/access_token'
    end

    def fetch_consumer_creditetntials
      @config[:consumer_key] = ask 'Enter your consumer_key:  '
      @config[:consumer_secret] = ask 'Enter your consumer secret:  '
    end

    def fetch_token_creditentials
      request_token = oauth_consumer.get_request_token
      Launchy.open request_token.authorize_url
      verifier = ask 'Authorize wheelbarrow and enter the verifier code you are assigned:  '
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
