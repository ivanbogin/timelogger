# get list of all commits prepared with dates which will go to toggl
# (dry-run param)

require_relative 'lib/github_parser'
require 'optparse'

options = {}
OptionParser.new do |opt|
  opt.on('-a',
         '--author AUTHOR',
         'Author of commits (guthub username)') do |o|
    options[:author] = o
  end
  opt.on('-r',
         '--repositories REPOSITORIES',
         'Repositories to parse, separated by comma') do |o|
    options[:repositories] = o
  end
  opt.on('-f',
         '--file FILENAME',
         'Export result to csv file with the specified name') do |o|
    options[:repositories] = o
  end
end.parse!

raise 'GITHUB_TOKEN must be set in environment' unless ENV['GITHUB_TOKEN']
raise 'Set repositories with -r REPOSITORIES' unless options[:repositories]
raise 'Set author with -a AUTHOR' unless options[:author]

repositories = options[:repositories].split(',').collect(&:strip)

parser = GithubParser.new options[ENV['GITHUB_TOKEN']], repositories
commits = parser.get_commits_by_author(options[:author])

require 'pry'; binding.pry
