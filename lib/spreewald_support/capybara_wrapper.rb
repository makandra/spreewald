module Spreewald
  class CapybaraWrapper
    def self.default_max_wait_time
      if Capybara.respond_to?(:default_max_wait_time)
        Capybara.default_max_wait_time
      else
        Capybara.default_wait_time
      end
    end

    def self.default_max_wait_time=(value)
      if Capybara.respond_to?(:default_max_wait_time=)
        Capybara.default_max_wait_time = value
      else
        Capybara.default_wait_time = value
      end
    end
  end
end
