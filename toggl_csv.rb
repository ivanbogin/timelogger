# get list of all commits prepared with dates which will go to toggl
# (dry-run param)

require_relative 'lib/github_browser'
require_relative 'lib/timesheet'
require 'optparse'

github_token = nil
OptionParser.new do |opt|
  opt.on('-t',
         '--token TOKEN',
         'Github token') do |o|
    github_token = o
  end
end.parse!

raise 'Set Github token with -t TOKEN' unless github_token

browser = GithubBrowser.new github_token

timesheet = TimeSheet.new

# Fetch own PRs
browser.created_pull_requests.each do |pr|
  timesheet.add pr.id, pr.created_at, pr.title
end

# Fetch commented PRs
browser.commented_pull_requests.each do |pr|
  if pr.user.login == browser.login
    title = pr.title
  else
    title = 'Peer Review: ' << pr.title
  end
  timesheet.add pr.id, pr.created_at, title
end

entries = timesheet.entries.sort

entries.each do |i, e|
  date = e[:date]
  description = e[:description]
  puts "#{date} #{description}"
end
