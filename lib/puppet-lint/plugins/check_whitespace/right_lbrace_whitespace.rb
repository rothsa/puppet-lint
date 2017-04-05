# Public: Check the manifest tokens for whitespace after the left bracket that is missing and record a warning for each instance found.
# #
# https://docs.puppet.com/guides/style_guide.html#spacing-indentation-and-whitespace
PuppetLint.new_check(:'right_lbrace_whitespace') do
  def check
    tokens.each do |token|
      unless token.next_token.nil?
        if token.type == :LBRACE 
          unless [:WHITESPACE, :NEWLINE].include?(token.next_token.type)
            notify :warning, {
              :message => 'space needed on right side of opening bracket',
              :line    => token.line,
              :column  => token.column,
              :token   => token,
            }
          end
        end
      end
    end
  end

  def fix(problem)
      tokens.insert(index, PuppetLint::Lexer::Token.new(:WHITESPACE, " ", 0, 0))
  end
end
