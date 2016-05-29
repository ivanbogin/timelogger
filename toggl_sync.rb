# get list of all commits prepared with dates which will go to toggl (dry-run param)

require_relative 'lib/github_parser'
require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.on('-g', '--github_token GITHUBTOKEN', 'Github auth token') { |o| options[:github_token] = o }
  opt.on('-t', '--toggl_token TOGGLTOKEN', 'Toggl auth token') { |o| options[:toggl_token] = o }
  opt.on('-a', '--author AUTHOR', 'Author of commits (guthub username)') { |o| options[:author] = o }
  opt.on('-r', '--repositories REPOSITORIES', 'Repositories to parse, separated by comma') { |o| options[:repositories] = o }
  opt.on('--dry', 'Dry run (do not export anything, just fetch data from guthub)') { |o| options[:dry] = o }
end.parse!

repositories = options[:repositories].split(',').collect(&:strip)

parser = GithubParser.new options[:github_token], repositories
commits = parser.get_commits_by_author(options[:author])
