# get list of all commits prepared with dates which will go to toggl
# (dry-run param)

require_relative 'lib/github_browser'
require_relative 'lib/timesheet'
require 'optparse'

github_token = nil
option_from = nil
OptionParser.new do |opt|
  opt.on('-t',
         '--token TOKEN',
         'Github token') do |o|
    github_token = o
  end
  opt.on('-d',
         '--date YYYYMMDD',
         'Starting date') do |o|
    option_from = o
  end
end.parse!

raise 'Set Github token with -t TOKEN' unless github_token
raise 'Set starting date with -d YYMMDD' unless option_from

browser = GithubBrowser.new github_token
timesheet = TimeSheet.new
date_from = Date.strptime(option_from, '%Y%m%d')

# Fetch own PRs
browser.created_pull_requests(date_from).each do |pr|
  timesheet.add pr.id, pr.created_at, pr.title, 7
end

# Fetch commented PRs (Code reviews)
browser.commented_pull_requests(date_from).each do |pr|
  next if pr.user.login == browser.login
  title = 'CR ' << pr.title
  timesheet.add pr.id, pr.created_at, title, 1
end

timesheet.calculated_entries.each do |e|
  puts "#{e[:date]};#{e[:description]};#{e[:time]};#{e[:duration]}"
end
