class Parser
  def normalize_git_message(message)
    message.tr("\n\r", "")
  end
end
