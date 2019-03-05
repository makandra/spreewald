module Spreewald
  module Compatibility

    def self.spreewald_failure_message(context, &block)
      if context.respond_to?(:failure_message)
        context.failure_message(&block)
      else
        context.failure_message_for_should(&block)
      end
    end

    def self.spreewald_failure_message_negated(context, &block)
      if context.respond_to?(:failure_message_when_negated)
        context.failure_message_when_negated(&block)
      else
        context.failure_message_for_should_not(&block)
      end
    end

  end
end
World(Spreewald::Compatibility)
