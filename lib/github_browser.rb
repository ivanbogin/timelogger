require 'octokit'

# Browsing github API
class GithubBrowser
  attr_reader :login

  def initialize(github_token)
    @client = Octokit::Client.new(access_token: github_token,
                                  auto_paginate: true)
    @login = @client.login
  end

  def created_pull_requests(date_from)
    created = date_from.to_s
    prs = @client.search_issues(
      "author:#{@login} type:pr created:>=#{created}"
    )
    prs.items
  end

  def mentioned_issues(date_from)
    created = date_from.to_s
    prs = @client.search_issues(
      "mentions:#{@login} created:>=#{created}"
    )
    prs.items
  end

  def normalize_git_message(message)
    message.tr!("\n\r", '')
    message.sub!(/merge.*into/i, '')
    message.strip
  end
end
