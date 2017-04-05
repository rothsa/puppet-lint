# Public: Check the manifest tokens for multiple spaces in whitespace that is not after a newline and record a warning for each instance found.
# #
# https://docs.puppet.com/guides/style_guide.html#spacing-indentation-and-whitespace
PuppetLint.new_check(:'multiple_whitespace') do
  def check
    puts tokens.map(&:type).inspect
    whitespace_tokens = tokens.select { |r| r.type == :WHITESPACE}
    whitespace_tokens.each do |token|
      if (token.value != " " && token.prev_token != :NEWLINE)
        notify :warning, {
          :message => 'multiple spaces found in whitespace that does not start line',
          :line    => token.line,
          :column  => token.column,
          :token   => token,
        }
      end
    end
  end

  def fix(problem)
    if problem[:token]
      problem[:token].value = " "
    end
  end
end
