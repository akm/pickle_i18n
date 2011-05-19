module PickleI18n::Parser
  def match_field
    # "(?:\\w+: #{match_value})"
    "(?:\s*[^:]+: #{match_value})"
  end

  def capture_key_and_value_in_field
    # "(?:(\\w+): #{capture_value})"
    "(?:\s*([^:]+): #{capture_value})"
  end
end
