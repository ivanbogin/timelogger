require 'github_browser'

RSpec.describe GithubBrowser, '#normalize_git_message' do
  it 'removes new lines from commit message' do
    parser = GithubBrowser.new 'test', 'test'
    result = parser.normalize_git_message(
      "Same shit, \nbetter smell, \r\nonly 1 query,\r\n\neasy to count."
    )
    expect(result).to eq 'Same shit, better smell, only 1 query,easy to count.'
  end

  it 'removes merge text from message' do
    parser = GithubBrowser.new 'test', 'test'
    result = parser.normalize_git_message(
      'Merge branch \'master\' of github.com:Company/API into ' \
      "TEST-1570-improve-webhooks. \r\nImportant text."
    )
    expect(result).to eq 'TEST-1570-improve-webhooks. Important text.'
  end
end
