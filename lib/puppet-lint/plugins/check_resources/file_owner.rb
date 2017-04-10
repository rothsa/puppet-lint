# issue a warning whenever the user attribute is used instead of the owner attribute for # file resources
# DISABLED by default
PuppetLint.new_check(:user_instead_of_owner) do
  def check
    resource_indexes.each do |resource|
      resource_tokens = tokens[resource[:start]..resource[:end]]
      prev_tokens = tokens[0..resource[:start]]

      lbrace_idx = prev_tokens.rindex { |r|
        r.type == :LBRACE
      }

      resource_type_token = tokens[lbrace_idx].prev_code_token
      if resource_type_token.value == "file"
        resource_tokens.select { |resource_token|
          resource_token.type == :NAME and resource_token.value == 'user'
        }.each do |resource_token|
          notify :warning, {
            :message    => 'file resource does not use user field; use owner instead',
            :linenumber => resource_token.line,
            :column     => resource_token.column,
            :token      => resource_token,
          }
        end
      end
    end
  end
end
PuppetLint.configuration.send("disable_file_owner")
