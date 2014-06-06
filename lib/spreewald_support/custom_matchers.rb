module CustomMatchers
  rspec = defined?(RSpec) ? RSpec : Spec

  rspec::Matchers.define :contain_with_wildcards do |expected_string|
    match do |field_value|
      @field_value = field_value.to_s
      @expected_string = expected_string
      regex_parts = expected_string.to_s.split('*', -1).collect { |part| Regexp.escape(part) }

      @field_value =~ /\A#{regex_parts.join(".*")}\z/m
    end

    failure_message_for_should do
      "The field's content #{@field_value.inspect} did not match #{@expected_string.inspect}"
    end

    failure_message_for_should_not do
      "The field's content #{@field_value.inspect} matches #{@expected_string.inspect}"
    end
  end

end
