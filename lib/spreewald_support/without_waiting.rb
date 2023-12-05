require 'spreewald_support/capybara_wrapper'

module Spreewald
  module WithoutWaiting
    def without_waiting
      prior_max_wait_time = CapybaraWrapper.default_max_wait_time
      CapybaraWrapper.default_max_wait_time = 0
      yield
    ensure
      CapybaraWrapper.default_max_wait_time = prior_max_wait_time
    end
  end
end
