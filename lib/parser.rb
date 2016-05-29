class Parser
  def normalize_git_message(message)
    message.tr!("\n\r", "")
    message.sub!(/merge.*into/i, '')
    message.strip
  end
end
