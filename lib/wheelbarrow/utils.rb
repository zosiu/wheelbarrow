module Wheelbarrow
  module Utils
    module_function

    def current_branch
      `git symbolic-ref HEAD`[%r{refs/heads/(.*)}, 1]
    end

    def git_repository?
      system('git rev-parse')
    end

    def ensure_within_git!
      git_repository? ? yield : fail('fatal: Not a git repository!')
    end

    def git_remotes
      `git remote -v`
    end

    def remote_url
      origin = git_remotes.split("\n")
               .map(&:strip)
               .grep(/^origin.*\(push\)$/)
               .first.to_s

      URI.extract(origin).first.to_s
    end

    def repo_name
      repo_name = remote_url.match repo_regex
      fail 'Repository does not seem to be hosted in BitBucket!' if repo_name.nil?
      repo_name[1]
    end

    def repo_regex
      /bitbucket\.org:(.*)\.git/
    end

    def last_commit_message
      `git log -1 --pretty=%B`.strip
    end
  end
end
