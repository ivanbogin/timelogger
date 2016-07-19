require 'octokit'

class GithubParser
  def initialize(github_token, repositories)
    @client       = Octokit::Client.new :access_token => github_token, :auto_paginate => true
    @repositories = repositories
  end

  def get_commits_by_author(author)
    author_commits = Hash.new

    @repositories.each do |repository|
      # get list of all repository branches
      branches = @client.branches repository

      branches.each do |b|
        # get all author commits inside branch
        commits = @client.commits(repository, :author => author, :sha => b.name)

        commits.each do |c|
          author_commits[c.sha] = { :date => c.commit.committer.date, :message => normalize_git_message(c.commit.message) }
        end
      end
    end

    author_commits
  end

  def normalize_git_message(message)
    message.tr!("\n\r", '')
    message.sub!(/merge.*into/i, '')
    message.strip
  end
end
