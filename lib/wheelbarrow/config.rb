require 'singleton'
require 'yaml'

module Wheelbarrow
  class Config
    include Singleton

    def fetch
      YAML.load_file config_file_path
    rescue Errno::ENOENT
      {}
    end

    def dump(config)
      create_config_dir

      File.open(config_file_path, 'w') { |f| YAML.dump config, f  }
    end

    def bitbucket_oauth_config
      { site: 'https://bitbucket.org',
        request_token_path: '/!api/1.0/oauth/request_token',
        authorize_path: '/!api/1.0/oauth/authenticate',
        access_token_path: '/!api/1.0/oauth/access_token' }
    end

    private

    def config_file_path
      "#{config_dir}/#{config_file_name}"
    end

    def config_file_name
      'config.yml'
    end

    def config_dir
      File.expand_path('~/.wheelbarrow')
    end

    def create_config_dir
      Dir.mkdir(config_dir) unless File.directory?(config_dir)
    end
  end
end
