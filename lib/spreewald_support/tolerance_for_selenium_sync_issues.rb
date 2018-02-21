module ToleranceForSeleniumSyncIssues
  RETRY_ERRORS = %w[
    Capybara::ElementNotFound
    Spec::Expectations::ExpectationNotMetError
    RSpec::Expectations::ExpectationNotMetError
    Minitest::Assertion
    Capybara::Poltergeist::ClickFailed
    Capybara::ExpectationNotMet
    Selenium::WebDriver::Error::StaleElementReferenceError
    Selenium::WebDriver::Error::NoAlertPresentError
    Selenium::WebDriver::Error::ElementNotVisibleError
    Selenium::WebDriver::Error::NoSuchFrameError
    Selenium::WebDriver::Error::NoAlertPresentError
    Selenium::WebDriver::Error::JavascriptError
    Selenium::WebDriver::Error::UnknownError
    Selenium::WebDriver::Error::NoSuchAlertError
  ]

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

  class PatientStack

    def initialize
      @stack ||= []
    end

    def add_segment(max_seconds)
      index = @stack.length
      segment = PatientStackSegment.new(@stack, index, max_seconds)
      @stack[index] = segment
      segment
    end

    def patiently(seconds, &block)
      segment = add_segment(seconds)

      begin
        block.call
      rescue Exception => e
        raise e unless RETRY_ERRORS.include?(e.class.name)
        raise e unless segment.seconds_left?
        sleep(0.05)
        raise Capybara::FrozenInTime, "time appears to be frozen, Capybara does not work with libraries which freeze time, consider using time travelling instead" if segment.frozen_time?
        retry
      ensure
        segment.done!
      end

    end

  end

  class PatientStackSegment

    def initialize(stack, index, max_seconds)
      @stack = stack
      @index = index
      @started_at = Time.now
      @max_seconds = max_seconds
    end

    attr_reader :max_seconds

    def seconds_elapsed
      Time.now - @started_at
    end

    def seconds_left
      max_seconds - seconds_elapsed
    end

    def seconds_left?
      seconds_left > 0
    end

    def frozen_time?
      Time.now == @started_at
    end

    def extend_seconds(additional_seconds)
      @max_seconds += additional_seconds
    end

    def done!
      if @index > 0
        @stack[@index - 1].extend_seconds(seconds_elapsed)
        @stack.pop
      end
    end

  end

  def patiently(seconds = CapybaraWrapper.default_max_wait_time, &block)
    return block.call unless page.driver.wait?
    @wait_stack ||= PatientStack.new
    @wait_stack.patiently(seconds, &block)
  end
end

World(ToleranceForSeleniumSyncIssues)
