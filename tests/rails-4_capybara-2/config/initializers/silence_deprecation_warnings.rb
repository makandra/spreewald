silenced = [
  /is deprecated and will be removed in Rails 5/,
] # list of warnings you want to silence

silenced_expr = Regexp.new(silenced.join('|'))

ActiveSupport::Deprecation.behavior = lambda do |msg, stack|
  unless msg =~ silenced_expr
    ActiveSupport::Deprecation::DEFAULT_BEHAVIORS[:stderr].call(msg, stack)
  end
end
