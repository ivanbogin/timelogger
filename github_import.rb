require 'octokit'

AUTHOR = 'ivanbogin'

raise "GITHUB_TOKEN must be set" unless ENV['GITHUB_TOKEN']

client = Octokit::Client.new :access_token => ENV['GITHUB_TOKEN']

#repositories = ['SEOshop/Backend', 'SEOshop/SEOshop', 'SEOshop/API']
repositories = ['SEOshop/Backend']

author_commits = Hash.new

repositories.each do |repository|
  # get list of all repository branches
  branches = client.branches repository

  branches.each do |b|
    # get all author commits inside branch
    commits = client.commits(repository, :author => AUTHOR, :sha => b.name)

    commits.each do |c|
      next if c.commit.message.start_with?('Merge ')
      author_commits[c.sha] = {:date => c.commit.committer.date, :message => c.commit.message}
    end
  end
end

author_commits.each do |sha, commit|
  puts "#{commit[:date]}\t#{commit[:message]}\n"
end
