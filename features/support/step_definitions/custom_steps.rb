Then /^the output should( not)? contain \/(.*)\/$/ do |negated, regexp|
  output = all_commands.map { |c| c.output }.join("\n")
  regexp = Regexp.new(regexp)

  if negated
    expect(output).not_to match(regexp)
  else
    expect(output).to match(regexp)
  end
end
