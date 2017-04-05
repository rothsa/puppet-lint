# Public: Check the manifest tokens for resource type declaration that has no whitespace before a colon and record a warning for each instance found.
# #
# https://docs.puppet.com/guides/style_guide.html#spacing-indentation-and-whitespace
PuppetLint.new_check(:colon_whitespace_before) do
  def check
    #puts tokens.map(&:type).inspect
    tokens.each do |token|
      unless token.prev_token.nil?
        if (token.type == :COLON && token.prev_token.type == :WHITESPACE)
        notify :warning, {
          :message => 'there should be no space before a colon',
          :line    => token.line,
          :column  => token.column,
          :token   => token,
        }
        end
      end
    end
  end

  def fix(problem)
    tokens.delete(problem[:token].prev_token)
  end
end
