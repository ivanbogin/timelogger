require 'parser'

RSpec.describe Parser, '#normalize_git_message' do
  it 'removes spaces from commit message' do
    parser = Parser.new
    result = parser.normalize_git_message("Same shit, \nbetter smell, \r\nonly 1 query,\r\n\neasy to count.")
    expect(result).to eq "Same shit, better smell, only 1 query,easy to count."
  end
end
