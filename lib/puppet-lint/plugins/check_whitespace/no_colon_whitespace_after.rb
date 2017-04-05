# Public: Check the manifest tokens for resource type declaration that has no whitespace after a colon, and record a warning for each instance found.
# #
# https://docs.puppet.com/guides/style_guide.html#spacing-indentation-and-whitespace
PuppetLint.new_check(:'no_colon_whitespace_after') do
  def check
    tokens.each do |token|
      unless token.next_token.nil? 
        if (token.type == :COLON && token.next_token.type != :WHITESPACE)
          notify :warning, {
            :message => 'there should be a space after the colon',
            :line    => token.line,
            :column  => token.column,
            :token   => token,
          }
        end
      end
    end
  end

  def fix(problem)
    if problem[:token]
      #tokens.insert(index, PuppetLint::Lexer::Token.new(:WHITESPACE, " ", 0, 0))
    end
  end
end
